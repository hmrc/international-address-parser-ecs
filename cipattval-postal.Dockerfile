FROM ubuntu:18.04
LABEL name=cipattval-postal
ENV PYTHONIOENCODING="UTF-8"
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# ENV FLASK_ENV=development
ENV FLASK_APP=cipattval-postal-server.py

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

RUN pip3 install postal flask

COPY cipattval-postal-server.py .

# EXPOSE 5000

# CMD python3 cipattval-postal-server.py
CMD ["flask", "run", "--host=0.0.0.0"] 
# CMD /bin/bash
