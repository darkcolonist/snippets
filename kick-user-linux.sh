# @author: Christian Noel Reyes <darkcolonist@gmail.com>
# @description: kick user in linux (must be root)
# @date: 2015-05-15
# @usage: sudo bash kick.sh <username>
# @usage: sudo bash kick.sh darkcolonist
who | grep $1 | awk '{print $2}' | while read -r line ; do
  echo locating all processes of $line by $1;
  ps -dN | grep $line | awk '{print $1}' | while read -r line2 ; do
    echo killing process $line2;
    kill -9 $line2;
  done;
done;
