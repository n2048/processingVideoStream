FROM ubuntu:14.04

## Install dependencies

RUN apt-get update -y 
RUN apt-get install xvfb libxrender1 libxtst6 libxi6 -y
RUN apt-get install default-jdk -y
RUN apt-get install wget nano unzip -y

## Install processing
RUN wget http://download.processing.org/processing-3.5.3-linux64.tgz
RUN tar -xzf processing-3.5.3-linux64.tgz
RUN rm processing-3.5.3-linux64.tgz

## install nginx 
RUN apt-get install build-essential libpcre3 libpcre3-dev libssl-dev -y

RUN wget http://nginx.org/download/nginx-1.9.6.tar.gz
RUN wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
RUN tar -zxvf nginx-1.9.6.tar.gz
RUN unzip master.zip
RUN cd nginx-1.9.6 && ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master; make; make install

## install avconv 
RUN apt-get install libav-tools -y

COPY ./nginx.conf /usr/local/nginx/conf/nginx.conf
COPY ./sketch/sketch.pde /sketch/sketch.pde
COPY ./run.sh ./run.sh

RUN chmod +x run.sh

ENV DISPLAY ":1"

EXPOSE 1935 8080 80

CMD /usr/local/nginx/sbin/nginx && Xvfb :1 -nocursor -screen 0 1024x768x24 </dev/null
