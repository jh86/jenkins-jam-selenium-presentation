all: build

build:
	perl generator.pl > build/index.html
	mkdir build/js
	cp js/remark-latest.min.js build/js

clean:
	rm -f *~
	rm -rf build/*

.PHONY: all build clean
