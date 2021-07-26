#!/bin/sh
# shellcheck disable=SC2155,SC2086

LABELS="${LABELS:-linter}"
RUNNER_WORKDIR="${RUNNER_WORKDIR:-_work}"

if [ -z "$GIT_PAT" ]; then
    echo "Missing environment variable github token (GIT_PAT)"
    exit 1
fi
if [ -z "$GIT_OWNER" ]; then
    echo "Missing environment variable github repository owner (GIT_OWNER)"
    exit 1
fi
if [ -z "$GIT_REPO" ]; then
    echo "Missing environment variable github repository name (GIT_REPO)"
    exit 1
fi

# If a kubeconfig env var exists, set it as the default kubeconfig
if [ -n "$KUBECONFIG_CONTENTS" ]; then
    mkdir -p ~/.kube
    echo "$KUBECONFIG_CONTENTS" > ~/.kube/config
fi
OS=linux
[ "$(uname -m)" = "Darwin" ] && OS=osx;
ARCH=$(uname -m)
case $ARCH in
  arm*) ARCH="arm";;
  aarch64) ARCH="arm64";;
  x86_64) ARCH="x64";;
esac

# The Github Action runner is installed in the entrypoint so that it always is running the latest version
# If the agent is installed in the docker container, a new version of the docker container needs to be published
# everytime a new version of the agent is released.
GIT_RUNNER_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | sed -e 's/^v//g')
echo "latest release: https://api.github.com/repos/actions/runner/releases/latest ${GIT_RUNNER_VERSION}"
DOWNLOAD_URL="https://github.com/actions/runner/releases/download/v${GIT_RUNNER_VERSION}/actions-runner-${OS}-${ARCH}-${GIT_RUNNER_VERSION}.tar.gz"
echo "Downloading: ${DOWNLOAD_URL}"
echo "Extracting in: $(pwd)"
curl -Ls "$DOWNLOAD_URL" | tar -zx

# Run the dependency installation script
sudo ./bin/installdependencies.sh

REGISTRATION_URL="https://api.github.com/repos/${GIT_OWNER}/${GIT_REPO}/actions/runners/registration-token"
echo "Requesting registration URL at '${REGISTRATION_URL}'"

payload=$(curl -sX POST -H "Authorization: token ${GIT_PAT}" ${REGISTRATION_URL})
export RUNNER_TOKEN=$(echo $payload | jq -r '.token')

./config.sh \
    --name "$(hostname)" \
    --token "${RUNNER_TOKEN}" \
    --url "https://github.com/${GIT_OWNER}/${GIT_REPO}" \
    --work "${RUNNER_WORKDIR}" \
    --labels "${LABELS}" \
    --unattended \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM
sleep 5
# Acknowledge the runner is running
if [ -n "$PING" ]; then
    if [ "$PING" != "ping" ]; then
        curl -H "Accept: application/vnd.github.everest-preview+json" \
            -H "Authorization: token ${GIT_TOKEN}" \
            --request POST \
            --data '{"event_type": "pong", "client_payload": {"pong": "'$PING'", "triggered": "'"$(date +%s)"'"}}' \
            https://api.github.com/repos/mathew-fleisch/runner-state/dispatches
    fi
fi
echo "./run.sh $*"
./run.sh "$*" &

wait $!

