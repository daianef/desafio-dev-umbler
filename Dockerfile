FROM erikap/ruby-sinatra:latest

MAINTAINER Daiane Fraga <daiane.a.fraga@gmail.com>

RUN apt-get update && apt-get install -y whois host
