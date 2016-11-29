alias pip2-update='pip2 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip2 install --user -U'
alias pip3-update='pip3 freeze --all --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip3 install --user -U'

alias python=python3
alias pip=pip3
