all: build release clean

build:
	@cd src && go build .

run: build
	@./src/main -theme themes/default.theme -config gorss.conf
	

release:
	@mkdir release
	@mkdir gorss
	@cd src && CC=x86_64-linux-musl-gcc CXX=x86_64-linux-musl-g++ GOARCH=amd64 GOOS=linux CGO_ENABLED=1 go build -ldflags "-linkmode external -extldflags -static -s -w" -o ../release/gorss_linux
	@cd src && go build -ldflags "-s -w" -o ../release/gorss_osx
	@cp gorss.conf gorss/
	@cp themes/default.theme gorss/
	@cp -r themes gorss/ 
	@mv release/gorss_linux gorss && tar cvfz gorss_linux.tar.gz gorss
	@rm gorss/gorss_linux
	@mv release/gorss_osx gorss && tar cvfz gorss_osx.tar.gz gorss
	@rm -rf release gorss

clean:
	rm -rf main gorss.log gorss.db release gorss *.tar.gz
