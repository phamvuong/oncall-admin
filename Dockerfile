FROM ubuntu:16.04

RUN export DEBIAN_FRONTEND=noninteractive \
    && apt-get update && apt-get -y dist-upgrade \
    && apt-get -y install libffi-dev libsasl2-dev python-dev libldap2-dev \
        libssl-dev sudo python-pip python-setuptools mysql-client virtualenv \ 
    && rm -rf /var/cache/apt/archives/*

RUN useradd -m -s /bin/bash oncall

COPY . /home/oncall/source
WORKDIR /home/oncall

EXPOSE 16652

RUN chown -R oncall:oncall /home/oncall/source \
    && sudo -Hu oncall virtualenv /home/oncall/env \
    && sudo -Hu oncall /bin/bash -c ' \
     source /home/oncall/env/bin/activate && cd /home/oncall/source \
     && python setup.py develop'


CMD ["sudo", "-EHu", "oncall", "bash", "-c", "source /home/oncall/env/bin/activate && make -C /home/oncall/source"]
