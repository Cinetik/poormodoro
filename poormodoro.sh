#!/bin/bash
# Author: dupp (emdupp@gmail.com)
# Description: Poor man's script to help reduce Internet related distractions while using the time management technique created by Francesco Cirillo

function black_list {
  if test -f black_list.txt; then
      cp /etc/hosts{,.bkp}
      while read line; do
          echo '127.0.0.1' $line >> /etc/hosts
      done < black_list.txt
  else
      echo "Black list does not exit!"
      exit 1
  fi
}

function clear_black_list {
  if test -f /etc/hosts.bkp; then
      rm /etc/hosts && mv /etc/hosts.bkp /etc/hosts
  else
      echo "Error no backuped up host file!"
      exit 1
  fi
}

function pomodoro {
  sequence_number=1
  sequence_total=4
  work_interval=60
  small_pause=5
  pause_interval=15
  while [ $sequence_number -le $sequence_total ]; do
      /usr/bin/osascript -e 'display notification "Black list starts now!" with title "poormodoro"'
      black_list
      sleep $work_interval
      /usr/bin/osascript -e 'display notification "Black list clears now!" with title "poormodoro"'
      clear_black_list
      if [ $sequence_number -eq $sequence_total ]; then
	sleep $pause_interval
      else
	sleep $small_pause
      fi

      let sequence_number=$sequence_number+1
  done
}
if [[ $(id -u) -ne 0 ]]; then
  echo "Use sudo to launch poormodoro!"
  exit 1
else
  pomodoro
fi
