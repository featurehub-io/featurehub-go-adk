OGEN := $(shell go env GOPATH)/bin/ogen
#OPENAPI_SPEC := api/mrapi-1.2.5.yaml
OPENAPI_SPEC := api/final.yaml
OPENAPI_URL  := https://raw.githubusercontent.com/featurehub-io/featurehub/refs/heads/main/infra/api-bucket/files/mrapi/1.2.5.yaml

.PHONY: all generate build test clean download-spec install-ogen

all: generate build test

$(OGEN):
	go install github.com/ogen-go/ogen/cmd/ogen@latest

install-ogen: $(OGEN)

download-spec:
	mkdir -p api
	curl -fsSL "$(OPENAPI_URL)" -o "$(OPENAPI_SPEC)"

generate: $(OGEN) $(OPENAPI_SPEC)
	$(OGEN) --target pkg/mrclient --package mrclient --config ogen.yml $(OPENAPI_SPEC)

build:
	go build ./...

test:
	go test ./...

clean:
	rm -f pkg/mrclient/oas_*_gen.go
