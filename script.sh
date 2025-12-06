# !/bin/bash

# Define the threshold values for CPU, and disk usage (in %)

CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

send_alert() {
    echo "$(tput setaf 1)ALERT: $1 usage exceeded threshold! Current value: $2%$(tput sgr0)"
}

while true; do

    # monitor cpu usage
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    cpu_usage=${cpu_usage%.*} # converts to integers


    if ((cpu_usage >= CPU_THRESHOLD))
    then
        send_alert "CPU" "$cpu_usage"
    fi

    # monitor memory usage
    memory_usage=$(free | awk '/Mem/ {printf("%3.1f", ($3/$2) * 100)}')
    
    memory_usage=${memory_usage%.*}

    if ((memory_usage >= MEMORY_THRESHOLD))
    then
        send_alert "MEMORY" "%memory_usage"
    fi



    # Monitor disk usage
    disk_usage=$(df -h / | awk '/\// {print $(NF-1)}')
    disk_usage=${disk_usage%?} # Remove the % sign
    

    if ((disk_usage >= DISK_THRESHOLD)); then
    send_alert "Disk" "$disk_usage"
    fi

    # display stats
    clear # clear screen
    echo "Current CPU usage: $cpu_usage%"
    echo "Current memory usage: $memory_usage%"
    echo "Current disk usage: $disk_usage%"
    sleep 2
done
