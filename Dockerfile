FROM erikap/ruby-sinatra:latest

MAINTAINER Daiane Fraga <daiane.a.fraga@gmail.com>

RUN apt-get update && apt-get install -y whois host

# Soluciona problemas de parser de JSON
ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
