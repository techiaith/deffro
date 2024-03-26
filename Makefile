default: build

build:
	docker build --rm -t techiaith/openwakewords .

# https://github.com/pytorch/pytorch?tab=readme-ov-file#docker-image
run:
	docker run --name techiaith-openwakewords \
		-it --ipc=host \
		-v ${PWD}/models:/models \
		-v ${PWD}/homedir:/root \
	techiaith/openwakewords

stop:
	-docker stop techiaith-openwakewords
	-docker rm techiaith-openwakewords

clean:
	-docker rmi techiaith/openwakewords
