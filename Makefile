VERSION=0.2.0

all: deps fmt combined

combined:
	go install .

release: tag release-deps dockerhub
	gox -output="build/{{.Dir}}_{{.OS}}_{{.Arch}}" .

fmt:
	go fmt ./...

deps:
	go get github.com/mailhog/MailHog-Server
	go get github.com/mailhog/MailHog-UI
	go get github.com/mailhog/mhsendmail
	cd src/github.com/mailhog/MailHog-UI; make bindata
	go get github.com/mailhog/http
	go get github.com/ian-kent/go-log/log
	go get github.com/ian-kent/envconf
	go get github.com/ian-kent/goose
	go get github.com/ian-kent/linkio
	go get github.com/jteeuwen/go-bindata/...
	go get labix.org/v2/mgo
	# added to fix travis issues
	go get golang.org/x/crypto/bcrypt
	patch src/github.com/mailhog/smtp/protocol.go protocol_changes.diff

test-deps:
	go get github.com/smartystreets/goconvey

release-deps:
	go get github.com/mitchellh/gox

pull:
	git pull
	cd ../data; git pull
	cd ../http; git pull
	cd ../MailHog-Server; git pull
	cd ../MailHog-UI; git pull
	cd ../smtp; git pull
	cd ../storage; git pull

tag:
	git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
	cd ../data; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
	cd ../http; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
	cd ../MailHog-Server; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
	cd ../MailHog-UI; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
	cd ../smtp; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}
	cd ../storage; git tag -a -m 'v${VERSION}' v${VERSION} && git push origin v${VERSION}

rocker: rocker-deps
	rocker build

rocker-deps:
	go get github.com/grammarly/rocker

dockerhub: rocker
	docker push mailhog/mailhog

.PHONY: all combined release fmt deps test-deps release-deps pull tag rocker rocker-deps
