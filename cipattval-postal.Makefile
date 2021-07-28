IMAGE_NAME = cip-attval/international-address-parser
CONTAINER_NAME = international-address-parser

.SILENT:

build:
	docker build -f cipattval-postal.Dockerfile . -t $(IMAGE_NAME)

run:
	docker run -d --name=$(CONTAINER_NAME) -p 8000:5000 $(IMAGE_NAME)

stop: 
	docker stop $(CONTAINER_NAME)

clean:
	docker rm --force $(CONTAINER_NAME)
	docker rmi --force $(IMAGE_NAME)

curl-test:
	curl --request POST  http://127.0.0.1:8000/normalize-and-categorize --header "Content-Type: application/json" --data '{"address":"The Book Club 100-106 Leonard St, Shoreditch, London, Greater London, EC2A 4RH, United Kingdom"}'

publish:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 710491386758.dkr.ecr.eu-west-2.amazonaws.com
	docker build -f cipattval-postal.Dockerfile -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest 710491386758.dkr.ecr.eu-west-2.amazonaws.com/$(IMAGE_NAME):latest
	docker push 710491386758.dkr.ecr.eu-west-2.amazonaws.com/$(IMAGE_NAME):latest
