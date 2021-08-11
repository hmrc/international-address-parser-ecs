IMAGE_NAME = cip-attval/international-address-parser
CONTAINER_NAME = international-address-parser
REPOSITORY_URI := $(shell sh -c "aws ecr describe-repositories --repository-names=$(IMAGE_NAME) --query 'repositories[].repositoryUri' | grep -v '^\]' | grep -v '^\[' | sed -E 's/[ \"]+//g'")
REPOSITORY_HOST := $(shell sh -c "echo $(REPOSITORY_URI) | sed -E 's/\/.*//g'")

.SILENT:

show-uri:
	echo $(REPOSITORY_URI)
	echo $(REPOSITORY_HOST)

build:
	docker build . -t $(IMAGE_NAME)

run:
	docker run -d --name=$(CONTAINER_NAME) -p 8000:5000 $(IMAGE_NAME)

stop: 
	docker stop $(CONTAINER_NAME)

clean:
	docker rm --force $(CONTAINER_NAME)
	docker rmi --force $(IMAGE_NAME)

test-normalize-endpoint:
	curl --request POST  http://127.0.0.1:8000/normalize --header "Content-Type: application/json" --data '{"address":"The Book Club 100-106 Leonard St, Shoreditch, London, Greater London, EC2A 4RH, United Kingdom"}'

test-categorize-endpoint:
	curl --request POST  http://127.0.0.1:8000/categorize --header "Content-Type: application/json" --data '{"address":"The Book Club 100-106 Leonard St, Shoreditch, London, Greater London, EC2A 4RH, United Kingdom"}'

test-normalize-and-categorize-endpoint:
	curl --request POST  http://127.0.0.1:8000/normalize-and-categorize --header "Content-Type: application/json" --data '{"address":"The Book Club 100-106 Leonard St, Shoreditch, London, Greater London, EC2A 4RH, United Kingdom"}'

test: test-normalize-endpoint test-categorize-endpoint test-normalize-and-categorize-endpoint

publish:
	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin $(REPOSITORY_HOST)
	docker build -t $(IMAGE_NAME) .
	docker tag $(IMAGE_NAME):latest $(REPOSITORY_URI):latest
	docker push $(REPOSITORY_URI):latest
