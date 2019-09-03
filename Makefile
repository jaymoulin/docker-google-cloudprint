VERSION ?= 0.4.5
CACHE ?= --no-cache=1
FULLVERSION ?= ${VERSION}
archs ?= s390x arm32v7 amd64 i386 arm64v8 arm32v6

.PHONY: all build publish latest
all: build publish latest
qemu-arm-static:
	cp /usr/bin/qemu-arm-static .
qemu-s390x-static:
	cp /usr/bin/qemu-s390x-static .
qemu-aarch64-static:
	cp /usr/bin/qemu-aarch64-static .
build: qemu-arm-static qemu-s390x-static qemu-aarch64-static
	$(foreach arch,$(archs), \
		cat Dockerfile | sed "s/FROM python:2-alpine/FROM ${arch}\/python:2-alpine/g" > .Dockerfile; \
		docker build -t jaymoulin/google-cloudprint:${VERSION}-$(arch) --build-arg VERSION=${VERSION}-$(arch) -f .Dockerfile ${CACHE} .;\
	)
publish:
	docker push jaymoulin/google-cloudprint
	cat manifest.yml | sed "s/\$$VERSION/${VERSION}/g" > manifest.yaml
	cat manifest.yaml | sed "s/\$$FULLVERSION/${FULLVERSION}/g" > manifest2.yaml
	mv manifest2.yaml manifest.yaml
	manifest-tool push from-spec manifest.yaml
latest: build
	FULLVERSION=latest VERSION=${VERSION} make publish
