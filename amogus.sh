#!/bin/bash

log_file="access.log"
target_date="11/Oct/2006"

grep "$target_date" "$log_file" | awk -F '"' '{print $6}' | sort | uniq | awk '{print $1}' | uniq -c | sort -rn > tmp

total_requests=$(head tmp | awk '{sum += $1} END {print sum}')

counter=1
while read -r line; do
    count=$(echo "$line" | awk '{print $1}')
    program=$(echo "$line" | awk '{print $2}')
    percentage=$(echo "scale=2; $count * 100 / $total_requests" | bc)
    echo "$counter. $program - $count - $percentage%"
    ((counter++))
    if [ $counter -gt 10 ]; then
        break
    fi
done < tmp
rm tmp