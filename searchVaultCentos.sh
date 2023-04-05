#!/bin/bash
# https://vault.centos.org/
# mirrors: 
#   europe
#     http://mirror.nsc.liu.se/centos-store/
#     rsync://mirror.nsc.liu.se::centos-store/
#   usa
#     http://archive.kernel.org/centos-vault/
#     rsync://archive.kernel.org::centos-vault/
set -eE
set -u  # turn on strict variable checking
# debugging
#set -x  # trace all function calls

function failure() { local lineno=$1;  local msg=$2
  echo "Failed at $lineno: $msg"
}
trap 'failure ${LINENO} "$BASH_COMMAND"' ERR ;#  trap [-lp] [[arg] sigspec ...], sigspec: ERR,EXIT,RETURN,DEBUG

IND="."; # indent

function accessMirror(){
    #local REGEX_HREF=".+href[^\>]+\>([^\<]+)\<" not working
    #wget -q $1 -O $WORK_FILE1
    readarray -t lines < <(wget -qO- $1 | grep -e "^<tr")
    for line in "${lines[@]}"; do
      #echo "$line"
      #  test line='<tr class="d"><td class="n"><a href="5.1/">5.1</a>'
      #       if [[ "$line" =~ ^\<tr[[:space:]]class=\"(.)\".+href[^\>]+\>([^\<]+)\< ]]; then echo "__${BASH_REMATCH[2]}__"; fi
      #                          <tr class="d"><td class="n"><a href="5.1/">5.1</a>       directory
      if [[ "$line" =~ ^\<tr[[:space:]]class=\"(.)\".+href[^\>]+\>([^\<]+)\< ]]; then
        echo "$2 OK1 ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}" # 
        if [ "${BASH_REMATCH[1]}" != "d" ]; then exit 1; fi  # throw exception
        local DIR_NAME=${BASH_REMATCH[2]}
        if [ "$DIR_NAME" != ".." ]; then
          if [ "$DIR_NAME" != "SRPMS" ]; then #TODO avoid loop: http://mirror.nsc.liu.se/centos-store/3.6/fasttrack/s390x/SRPMS/
            accessMirror "$1/$DIR_NAME" "$2$IND"
          fi
        else
          echo "$1" ; #debugging
        fi
      else
      #<tr><td class="n"><a href="RPM-GPG-KEY-CentOS-4">RPM-GPG-KEY-CentOS-4</a>   node
      if [[ "$line" =~ ^\<tr\>\<td[[:space:]]class=\"(.)\".+href[^\>]+\>([^\<]+)\< ]]; then
        echo "$2 OK2 ${BASH_REMATCH[1]} ${BASH_REMATCH[2]}" # bar
        if [ "${BASH_REMATCH[1]}" != "n" ]; then exit 1; fi  
      fi
      fi
    done # for
}
accessMirror http://mirror.nsc.liu.se/centos-store/ $IND ;#EUROPE
#accessMirror http://archive.kernel.org/centos-vault/ $IND ;#USA
#accessMirror http://mirror.nsc.liu.se/centos-store/2.1/extras/SRPMS  $IND;# test
#accessMirror http://mirror.nsc.liu.se/centos-store/2.1/extras  $IND ;# test
