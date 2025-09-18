#!/usr/bin/env bash
ALERT_LOG="./system_health_alerts.log"
CPU_THRESH=80
MEM_THRESH=80
DISK_THRESH=85

timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

echo "$(timestamp) - Running system health check" >> "$ALERT_LOG"

cores=$(nproc)
load=$(cat /proc/loadavg | awk '{print $1}')
cpu_usage=$(awk -v l="$load" -v c="$cores" 'BEGIN { printf("%.0f", (l/c)*100) }')

mem_used=$(free -m | awk '/^Mem:/ {print $3}')
mem_total=$(free -m | awk '/^Mem:/ {print $2}')
mem_perc=$(( mem_used * 100 / mem_total ))

disk_perc=$(df -h / | awk 'NR==2 { gsub("%","",$5); print $5 }')

top_procs=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6)

ALERTS=()

if [ "$cpu_usage" -gt "$CPU_THRESH" ]; then
  ALERTS+=("CPU usage high: ${cpu_usage}% (threshold ${CPU_THRESH}%)")
fi
if [ "$mem_perc" -gt "$MEM_THRESH" ]; then
  ALERTS+=("Memory usage high: ${mem_perc}% (threshold ${MEM_THRESH}%)")
fi
if [ "$disk_perc" -gt "$DISK_THRESH" ]; then
  ALERTS+=("Disk usage high: ${disk_perc}% (threshold ${DISK_THRESH}%)")
fi

if [ ${#ALERTS[@]} -gt 0 ]; then
  echo "$(timestamp) - ALERTS DETECTED" | tee -a "$ALERT_LOG"
  for a in "${ALERTS[@]}"; do
    echo "$(timestamp) - $a" | tee -a "$ALERT_LOG"
  done
  echo "$(timestamp) - Top processes by CPU:" | tee -a "$ALERT_LOG"
  echo "$top_procs" | tee -a "$ALERT_LOG"
else
  echo "$(timestamp) - OK: cpu=${cpu_usage}% mem=${mem_perc}% disk=${disk_perc}%" >> "$ALERT_LOG"
fi
