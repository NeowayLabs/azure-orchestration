FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

RUN apt-get -qqy update && \
	apt-get -qqy install python python-pip && \
	apt-get -qqy autoremove && \
	apt-get -qqy clean && \
	rm -rf /var/lib/apt/*

COPY requirements.txt /requirements.txt

RUN pip install -r /requirements.txt
