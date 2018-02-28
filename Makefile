page:
	git subtree split -P dist -b gh-pages

push-page:
	git push origin gh-pages:gh-pages
