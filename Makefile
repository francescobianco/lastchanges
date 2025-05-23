

build:
	@mush build --release

push: build
	@git add .
	@git commit -am "New release!" || true
	@git push

release: push
	@mush publish --allow-dirty
