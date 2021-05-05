if command -v minikube > /dev/null; then
    minikube_env() {
        eval "$(minikube docker-env)"
        export TEST_HOST="$(echo "$DOCKER_HOST" | tr '/' ' ' | tr ':' ' ' | awk '{print $2}')"
    }
fi
