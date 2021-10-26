.PHONY: all
all: build push

.PHONY: build
build:
	docker build --tag emyrk/coder-rstudio:latest .

.PHONY: push
push: build
	docker push emyrk/coder-rstudio:latest

.PHONY:
start: build
	docker run --rm -it --entrypoint="/bin/bash" --name rstudio emyrk/coder-rstudio:latest
