path=(~/.rbenv/shims "$path[@]")

if [[ -d ~/.gem/ruby/ ]]; then
    for dir in ~/.gem/ruby/*/bin; do
        path=($dir "$path[@]")
    done 2> /dev/null
fi
