zwatch() {
    local sleeptime=2
    local help='usage: zwatch [-n TIMEOUT] command'

    if [ "$1" = '-n' ]; then
        sleeptime="$2"
        shift
        shift
    elif [ "$1" = '--help' ] || [ "$1" = '-h' ]; then
        echo "$help"
        return 0
    elif [ -z "$1" ]; then
        echo "$help" >&2
        return 1
    fi
    while True; do
        clear
        echo "$(date) - sleep $sleeptime"
        echo -n "$@" | cut -c1-$COLUMNS
        echo
        eval "$@"
        sleep "$sleeptime"
    done
}
