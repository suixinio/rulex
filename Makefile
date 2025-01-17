APP=rulex
.PHONY: all
all:
	make build

.PHONY: build
build:
	chmod +x gen_info.sh
	go generate
	CGO_ENABLED=1 GOOS=linux
	go build -v -ldflags "-s -w" -o ${APP}

.PHONY: x64linux
x64linux:
	CGO_ENABLED=1 GOOS=linux GOARCH=amd64 CC=gcc\
	    go build -ldflags "-s -w -linkmode external -extldflags -static" -o ${APP}-x64linux

.PHONY: windows
windows:
	GOOS=windows go build -ldflags "-s -w" -o ${APP}.exe

.PHONY: arm32
arm32:
	CGO_ENABLED=1 GOOS=linux GOARCH=arm CC=arm-linux-gnueabi-gcc\
	    go build -ldflags "-s -w -linkmode external -extldflags -static" -o ${APP}-arm32

.PHONY: arm64
arm64:
	CGO_ENABLED=1 GOOS=linux GOARCH=arm64 CC=aarch64-linux-gnu-gcc\
	    go build -ldflags "-s -w -linkmode external -extldflags -static" -o ${APP}-arm64

.PHONY: mips32
mips32:
	# sudo apt-get install gcc-mips-linux-gnu
	GOOS=linux GOARCH=mips CGO_ENABLED=1 CC=mips-linux-gnu-gcc\
	    go build -ldflags "-s -w -linkmode external -extldflags -static" -o ${APP}-mips32

.PHONY: mips64
mips64:
	# sudo apt-get install gcc-mips-linux-gnu
	GOOS=linux GOARCH=mips64 CGO_ENABLED=1 CC=mips-linux-gnu-gcc\
	    go build -ldflags "-s -w -linkmode external -extldflags -static" -o ${APP}-mips64

.PHONY: mipsel
mipsle:
	# sudo apt-get install gcc-mipsel-linux-gnu
	GOOS=linux GOARCH=mipsle CGO_ENABLED=1 GOMIPS=softfloat CC=mipsel-linux-gnu-gcc\
	    go build -ldflags "-s -w -linkmode external -extldflags -static" -o ${APP}-mipsle

.PHONY: run
run:
	go run -race run

.PHONY: test
test:
	go test rulex/test -v

.PHONY: cover
cover:
	go test rulex/test -v -cover

.PHONY: clean
clean:
	go clean
	rm _release -rf
	rm *.db *log.txt -rf
