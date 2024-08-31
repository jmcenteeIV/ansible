#!/bin/bash
hosts=( "192.168.1.39" "192.168.1.40" "192.168.1.41" "192.168.1.42" )
password=""
touch log.txt
while true; do
    echo "Trying to ssh to hosts ${hosts[3]}"
    for host in "${hosts[@]}"; do
        echo "Trying to ssh to $host"
        start=$(date +%s)
        echo "Start time: $start for host $host" >> log.txt
        sshpass -p $password ssh -o StrictHostKeyChecking=no -vvv admin@$host "echo 'SSH to $host is working'" 2>&1 | ts >> log.txt
        end=$(date +%s)
        echo "End time: $end for host $host" >> log.txt
        echo "Time taken: $((end-start)) seconds" >> log.txt
    done
    sleep 5
done