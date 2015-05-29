#!/bin/bash
set -x

function black_list {
  if test -f black_list.txt; then
      cp /etc/hosts{,.bkp}
      while read line; do
          echo '127.0.0.1' $line >> /etc/hosts
      done < black_list.txt
      #flush dns cache
      service dnsmasq restart
  else
      echo "Does not exit!"
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
  while [ $sequence_number -lt $sequence_total ]; do
      echo "blacklist starts for 60 secs"
      black_list
      echo "start working"
      sleep 30
      echo "blacklist cleared for 15 secs"
      clear_black_list
      echo "pause starts"
      sleep 15
      $sequence_number=$sequence_number+1
  done
}
if [[ $(id -u) -ne 0 ]]; then
  echo "Use sudo to launch poormodoro!"
  exit 1
else
  pomodoro
fi
