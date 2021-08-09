FROM ubuntu:18.04
LABEL name=international-address-parser-server
ENV PYTHONIOENCODING="UTF-8"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# ENV FLASK_ENV=development
ENV FLASK_APP=international-address-parser-server.py

RUN apt update && \
  apt upgrade -y && \
  apt install -y curl autoconf automake libtool python-dev pkg-config git && \
  apt install python3 python3-pip nano -y

WORKDIR /work/working
RUN git clone https://github.com/openvenues/libpostal && \
  cd libpostal && \
  ./bootstrap.sh && \
  ./configure --datadir=$(pwd)/data && \
  make && \
  make install && \
  ldconfig

RUN pip3 install postal flask waitress

WORKDIR /work
COPY international-address-parser-server.py .

EXPOSE 5000

#CMD ["flask", "run", "--host=0.0.0.0"]
CMD ["python3", "international-address-parser-server.py"]
