#!/bin/bash

LOG=$(journalctl --since "24 hour ago" -u mina-bp-stats-sidecar.service --no-hostname | grep "Finished! New tip")
FIRST_LINE=$(echo -e "${LOG}" | head -n 1)
LAST_LINE=$(echo -e "${LOG}" | tail -n 1)

BLOCK_NUMBERS=$(echo -e "${LOG}"  | grep -o '[0-9]\+\.\.\.' | grep -o '[0-9]\+' | uniq)

FIRST=$(echo -e "${BLOCK_NUMBERS}" | head -n 1)
LAST=$(echo -e "${BLOCK_NUMBERS}" | tail -n 1)
echo -e "Checked  interval:\n${FIRST_LINE}\n...\n${LAST_LINE}\n\nMissed report for blocks:"

COUNTER=0
for ((i=$FIRST; i < LAST; i++))
do
 if ! [[ $LOG == *"$i"* ]]; then
  echo $i
  ((COUNTER++))
 fi
done

echo -e "STATS from ${FIRST} to ${LAST} blocks.\nTotal Skipped:${COUNTER} from $(bc -l <<<"${LAST} - ${FIRST}")"
