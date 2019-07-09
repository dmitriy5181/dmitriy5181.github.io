all:
	@echo "dummy default target, use 'make publish'"

publish:
	rm -rf public
	hugo
	python3 -m ghp_import --branch=master --message="Generate site" --push public