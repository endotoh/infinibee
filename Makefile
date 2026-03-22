.PHONY: build publish

build:
	python3 build.py

publish: build
	git add -A
	git commit -m "Update vocabulary and rebuild"
	git push
