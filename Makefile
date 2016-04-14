all: build

build:
	perl -p -e "s|\$$|\\\$$|g" README.md > build/README.md
	perl -p -e "s|</textarea>|"$(cat build/README.md)"</textarea>|" index.html > build/index.html
	cp remark-latest.min.js build/

clean:
	rm -f *~

.PHONY: all build clean
