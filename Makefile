.PHONY: trigger-asdf-update
trigger-asdf-update:
	curl -H "Accept: application/vnd.github.everest-preview+json" \
	    -H "Authorization: token $(GIT_TOKEN)" \
	    --request POST \
	    --data '{"event_type": "trigger-asdf-update"}' \
	    https://api.github.com/repos/mathew-fleisch/linter-runner/dispatches

# .PHONY: build
# build:
# 	docker build -t linter-runner .

.PHONY: build-alpine
build-alpine:
	docker build -t linter-runner-alpine . -f Dockerfile.alpine

.PHONY: build-ubuntu
build-ubuntu:
	docker build -t linter-runner-ubuntu . -f Dockerfile.ubuntu

# .PHONY: run
# run:
# 	docker run -it --rm \
# 		-e GIT_PAT="$(GIT_TOKEN)" \
# 		-e GIT_OWNER="mathew-fleisch" \
# 		-e GIT_REPO="github-actions-runner" \
# 		-e LABELS="gha-linter-runner" \
# 		--name "gha-linter-runner" \
# 		linter-runner:latest

# .PHONY: debug
# debug:
# 	docker run -it --rm \
# 		-e GIT_PAT="$(GIT_TOKEN)" \
# 		-e GIT_OWNER="mathew-fleisch" \
# 		-e GIT_REPO="github-actions-runner" \
# 		-e LABELS="gha-linter-runner" \
# 		--name "gha-linter-runner" \
# 		--entrypoint /bin/bash \
# 		linter-runner:latest


.PHONY: run-alpine
run-alpine:
	docker run -it --rm \
		-e GIT_PAT="$(GIT_TOKEN)" \
		-e GIT_OWNER="mathew-fleisch" \
		-e GIT_REPO="github-actions-runner" \
		-e LABELS="gha-linter-runner" \
		--name "gha-linter-runner" \
		linter-runner-alpine:latest

.PHONY: debug-alpine
debug-alpine:
	docker run -it --rm \
		-e GIT_PAT="$(GIT_TOKEN)" \
		-e GIT_OWNER="mathew-fleisch" \
		-e GIT_REPO="github-actions-runner" \
		-e LABELS="gha-linter-runner" \
		--name "gha-linter-runner" \
		--entrypoint /bin/bash \
		linter-runner-alpine:latest


.PHONY: run-ubuntu
run-ubuntu:
	docker run -it --rm \
		-e GIT_PAT="$(GIT_TOKEN)" \
		-e GIT_OWNER="mathew-fleisch" \
		-e GIT_REPO="github-actions-runner" \
		-e LABELS="gha-linter-runner" \
		--name "gha-linter-runner" \
		linter-runner-ubuntu:latest

.PHONY: debug-ubuntu
debug-ubuntu:
	docker run -it --rm \
		-e GIT_PAT="$(GIT_TOKEN)" \
		-e GIT_OWNER="mathew-fleisch" \
		-e GIT_REPO="github-actions-runner" \
		-e LABELS="gha-linter-runner" \
		--name "gha-linter-runner" \
		--entrypoint /bin/bash \
		linter-runner-ubuntu:latest
