#!/bin/bash
destroyFileContent () {
  echo "destroying content of: $1"
  FILE_SIZE=`stat --printf="%s" $1`
  dd if=/dev/zero of=$1 bs=$FILE_SIZE count=1 > /dev/null 2>&1
}

destroyFile () {
  destroyFileContent $1
  yes | rm $1
}

destroyFolder () {
  find $1 -type f | while read file; do destroyFile $file; done
  yes | rm -r $1
}

destroy () {
  if [ -d "$1" ]
  then
    echo "\"$1\" is directory."
    destroyFolder $1
  elif [ -e "$1" ]
  then
    echo "\"$1\" is file."
    destroyFile $1
  fi
}

if [ $# -lt 1 ]
then 
  echo "$0: please provide at least one file to destroy"
  exit 0
fi

question=`printf "You are going to destroy $# files.\nAre you sure?"`
dialog --title "Data destroyer" --yesno "$question" 10 40
case $? in
  0)
    for arg in "$@"
    do
        destroy $arg
    done;;
  1)
    clear
    exit 0;;
  255)
    exit 1;;
esac
