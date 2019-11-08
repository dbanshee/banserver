if [ $# != 1 ] ; then
  echo "Bag usage. loadg <process_name>"
  exit -1
fi

ps -C "$1" --no-headers -o pmem | xargs | sed -e 's/ /+/g' | bc



# termsql command
#ps -C chromium-browser -o pmem | termsql -1 "SELECT SUM([%MEM]) FROM tbl"
