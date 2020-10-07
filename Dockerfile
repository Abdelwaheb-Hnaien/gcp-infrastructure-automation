FROM centos:7

RUN yum -y update && yum clean all

COPY  templating.py .

COPY  builder.sh .

RUN yum --enablerepo=extras install epel-release -y

RUN yum -y install python-devel git wget curl unzip python-pip gcc && yum clean all

RUN pip install jinja2 pyyaml

RUN wget https://releases.hashicorp.com/terraform/0.12.0/terraform_0.12.0_linux_amd64.zip -P /tmp && unzip /tmp/terraform_0.12.0_linux_amd64.zip -d /usr/bin && rm -rf /tmp/* && rm -rf /var/tmp/*

#RUN curl https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz | tar xzf - -C /

#RUN ls

#RUN rm -f go1.12.4.linux-amd64.tar.gz

#ENV GOPATH /go

#ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

#RUN curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

#RUN mkdir -p go/src/infra_unit_test

#RUN dep init go/src/infra_unit_test/

#COPY dependencies.go go/src/infra_unit_test/

#WORKDIR go/src/infra_unit_test/

#RUN dep ensure

#RUN rm -f dependencies.go

RUN yum clean all && \
    rm -rf /var/cache/yum

RUN chmod 777 builder.sh

WORKDIR /

ENTRYPOINT ["/builder.sh"]