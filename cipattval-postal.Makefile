build:
	@docker build -f cipattval-postal.Dockerfile . -t cipattval-postal

run: build
	@docker run -d --name=cipattval-postal -p 8000:5000 cipattval-postal

stop: 
	@docker stop cipattval-postal
	@docker rm --force cipattval-postal
	@docker rmi --force cipattval-postal

curl-test:
	@curl --request POST  http://127.0.0.1:8000/normalize --header "Content-Type: application/json" --data '{"address":"The Book Club 100-106 Leonard St, Shoreditch, London, Greater London, EC2A 4RH, United Kingdom"}'
