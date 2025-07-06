#Path for the log file
LOGFILE="system_info.txt"

#Diagnostic Functions
write_header() {
    echo "System information – $(date)" > "$LOGFILE"
    echo "----------------------------"  >> "$LOGFILE"
}

log_uptime() {
    echo -e "\nUptime:"                >> "$LOGFILE"
    uptime                            >> "$LOGFILE"
}

log_memory() {
    echo -e "\nMemory usage:"          >> "$LOGFILE"
    free -h                           >> "$LOGFILE"
}

log_disk() {
    echo -e "\nDisk usage:"            >> "$LOGFILE"
    df -h                             >> "$LOGFILE"
}

log_cpu() {
    echo -e "\nCPU information:"       >> "$LOGFILE"
    lscpu                              >> "$LOGFILE"
}

log_network() {
    echo -e "\nNetwork interfaces:"    >> "$LOGFILE"
    ip a                               >> "$LOGFILE"
}

log_top_processes() {
    echo -e "\nTop processes:"         >> "$LOGFILE"
    ps aux --sort=-%cpu | head -n 5    >> "$LOGFILE"
}

log_system_logs() {
    echo -e "\nSystem logs (last 20 lines):" >> "$LOGFILE"
    tail -n 20 /var/log/syslog 2>/dev/null   >> "$LOGFILE" \
        || echo "No syslog found"            >> "$LOGFILE"
}

write_footer() {
    echo -e "\nReport complete." >> "$LOGFILE"
}

run_full_report() {
    write_header
    log_uptime
    log_memory
    log_disk
    log_cpu
    log_network
    log_top_processes
    log_system_logs
    write_footer
}

#Main While Loop
while true; do
    clear
    echo "----- MyLinuxHealthCheck -----"
    echo
    echo "1) System information (full report)"
    echo "2) CPU and memory diagnostics"
    echo "3) Disk diagnostics"
    echo "4) Network diagnostics"
    echo "5) Uptime and load monitoring"
    echo "6) Exit"
    echo
    read -rp "Select an option: " x

    case "$x" in
        1)
            run_full_report
            echo -e "\nReport saved to $LOGFILE."
            read -rp "1) Back to menu  2) View log now: " y
            [[ "$y" = "2" ]] && less "$LOGFILE"
            ;;
        2)
            log_cpu; log_memory
            less +G "$LOGFILE"
            ;;
        3)
            log_disk
            less +G "$LOGFILE"
            ;;
        4)
            log_network
            less +G "$LOGFILE"
            ;;
        5)
            log_uptime
            less +G "$LOGFILE"
            ;;
        6)  echo "Good‑bye!"; break ;;
        *)  echo "Invalid choice"; sleep 1 ;;
    esac
done