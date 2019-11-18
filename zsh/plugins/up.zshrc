up() {
    for i in {1.."$1"};
    do
        if [[ -t 1 ]] then
            cd ..
        else
            echo -n ../
        fi
    done
}
