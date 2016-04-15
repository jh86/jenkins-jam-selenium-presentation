all: build

build:
	perl generator.pl > build/index.html
	-mkdir build/img build/js
	cp js/remark-latest.min.js build/js
	cp -R img/* build/img/

clean:
	rm -f *~
	rm -rf build/*

.PHONY: all build clean
