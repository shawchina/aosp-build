all: build

build:
	docker build -t shawchina/yocto-build .

run:
	docker run -it shawchina/yocto-build

deploy:
	docker push shawchina/yocto-build
