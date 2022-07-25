FROM centos:centos7
COPY ./src/CentOS-Base.repo etc/yum.repos.d/
RUN yum install -y python3
RUN pip3 install flask && \
    pip3 install flask-jsonpify && \
    pip3 install flask-restful
RUN mkdir /python_api
COPY ./src/python-api.py /python_api
WORKDIR /python_api
CMD [ "python3", "python-api.py" ]
