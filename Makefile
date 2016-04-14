all: build

build:
	perl generator.pl > build/index.html
	cp remark-latest.min.js build/

clean:
	rm -f *~

.PHONY: all build clean
