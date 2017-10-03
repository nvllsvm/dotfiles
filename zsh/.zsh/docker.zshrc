docker-compose-port() {
    docker-compose port "$1" $2 | cut -d: -f2
}
