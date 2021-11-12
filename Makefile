.PHONY: build

public/slides.pptx: slides.md
	mkdir -p public/
	pandoc $< -o $@

public/index.html: slides.md
	mkdir -p public/
	pandoc --standalone -t revealjs -o $@ --slide-level 3 $<

build: public/index.html
	cp -v ./assets/* public/
