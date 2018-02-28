all: build page push-page

build:
	rsync -av --delete src/ dist/

page:
	git subtree split -P dist -b gh-pages

push-page:
	git push origin gh-pages:gh-pages
