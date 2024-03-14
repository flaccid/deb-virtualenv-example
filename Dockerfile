FROM debian:bookworm
COPY . /usr/local/src/helloart
RUN apt-get update && \
	apt-get -y install \
		python-is-python3 \
		python3-pip
WORKDIR /usr/local/src/helloart
ENV PIP_BREAK_SYSTEM_PACKAGES=1
RUN pip install -r requirements.txt && \
	python setup.py install
CMD ["python", "serve.py"]
