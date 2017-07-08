# bin/bh

docker build -t ruby-whois .

docker run \
	--name domain-explorer \
	-p 80:80 \
	-v $PWD:/usr/src/app \
	-e MAIN_APP_FILE=example/myapp.rb \
	-d ruby-whois