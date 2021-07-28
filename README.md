# Linter (github action runner)

[![Release CI: multi-arch container build & push](https://github.com/mathew-fleisch/linter-runner/actions/workflows/build-container.yaml/badge.svg)](https://github.com/mathew-fleisch/linter-runner/actions/workflows/build-container.yaml)
[Docker Hub](https://hub.docker.com/r/mathewfleisch/linter-runner/tags?page=1&ordering=last_updated)


This repository holds instructions for a light-weight self-hosted github-action runner container definition.

```bash
# To build:
make build-ubuntu

# To run locally:
make run-ubuntu

# To debug locally
make debug-ubuntu
```



## Known issues

Building an alpine based github-action runner doesn't seem to work. I have looked at many similar issues, but was not able to get it working

Links I followed to get to this point

 - https://github.community/t/is-there-any-way-to-build-raspbian-artifacts-in-actions/17357/5
 - https://github.com/IBM/node-red-tensorflowjs/issues/12 ([Dockerfile.alpine:L12](Dockerfile.alpine:L12))
 - https://stackoverflow.com/questions/50288034/unsatisfiedlinkerror-tmp-snappy-1-1-4-libsnappyjava-so-error-loading-shared-li/51655643#51655643
    - libc6-compat changed nothing in my error responses
 - https://www.atlascode.com/blog/running-asp-net-core-in-an-alpine-linux-docker-container/
 - https://dustri.org/b/error-loading-shared-library-ld-linux-x86-64so2-on-alpine-linux.html
    - I did not know what binary to `ldd`



```bash
# Final error I could not resolve

make run-alpine
    docker run -it --rm \
        -e GIT_PAT="REDACTED" \
        -e GIT_OWNER="mathew-fleisch" \
        -e GIT_REPO="github-actions-runner" \
        -e LABELS="gha-linter-runner" \
        --name "gha-linter-runner" \
        linter-runner-alpine:latest
# latest version: 2.279.0
# --------OS Information--------
# NAME="Alpine Linux"
# ID=alpine
# VERSION_ID=3.14.0
# PRETTY_NAME="Alpine Linux v3.14"
# HOME_URL="https://alpinelinux.org/"
# BUG_REPORT_URL="https://bugs.alpinelinux.org/"
# ------------------------------

# Can't detect current OS type based on /etc/os-release.
# Can't install dotnet core dependencies.
# You can manually install all required dependencies based on following documentation
# https://docs.microsoft.com/en-us/dotnet/core/linux-prerequisites?tabs=netcore2x
# Requesting registration URL at 'https://api.github.com/repos/mathew-fleisch/github-actions-runner/actions/runners/registration-token'
# Error relocating ./bin/libcoreclr.so: __finite: symbol not found
# Error relocating ./bin/libcoreclr.so: __isnan: symbol not found
# Error relocating ./bin/libcoreclr.so: __finitef: symbol not found
# Error relocating ./bin/libcoreclr.so: __isnanf: symbol not found
# Error relocating ./bin/libcoreclr.so: pthread_attr_setaffinity_np: symbol not found
# Libicu's dependencies is missing for Dotnet Core 3.0
# Execute sudo ./bin/installdependencies.sh to install any missing Dotnet Core 3.0 dependencies.
# ./run.sh 
# ./run.sh: line 49:    54 Segmentation fault      "$DIR"/bin/Runner.Listener run $*
# make: *** [run-alpine] Error 139

```


