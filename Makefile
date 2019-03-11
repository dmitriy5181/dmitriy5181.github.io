all:
	@echo "dummy default target, use 'make publish'"

publish:
	rm -rf public
	hugo
	ghp-import --branch=master --message="Generate site" --push public