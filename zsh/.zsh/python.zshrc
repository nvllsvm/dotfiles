alias pip-upgrade='pip freeze --local --user | grep -v '^\-e' | cut -d = -f 1 | xargs pip install --user -U'
