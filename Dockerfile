# To build image:
# docker build -t asciidoctor-builder:latest -f Dockerfile .
# To run image:
# docker run -it --name asciidoctor-builder --rm -v $(pwd):/workspace -p 4242:4242 asciidoctor-builder:latest
# curl -v localhost:4242/docs/asciidoctor-diagram/

FROM fedora:24
MAINTAINER Asciidoctor

LABEL Description="This image provides the toolchain for building the asciidoctor.org website."

RUN echo "deltarpm=false" >> /etc/dnf/dnf.conf

RUN dnf -y update
RUN dnf -y install \
  git \
  libffi-devel \
  libxml2-devel \
  libxslt-devel \
  net-tools \
  graphviz \
  java-1.8.0-openjdk \
  patch redhat-rpm-config \
  ruby-devel \
  rubygem-bundler
RUN dnf -y groupinstall "C Development Tools and Libraries"
RUN dnf clean all

RUN echo -e "To launch site, use the following command:\n\n $ bundle exec rake preview\n $ bundle exec rake gen" > /etc/motd && \
  echo "[ -v PS1 -a -r /etc/motd ] && cat /etc/motd" > /etc/profile.d/motd.sh


ENV LANG en_US.UTF-8

RUN git clone --single-branch --depth 1 https://github.com/mrduguo/asciidoctor.org /workspace
WORKDIR /workspace

RUN bundle config --local build.nokogiri --use-system-libraries
RUN bundle

EXPOSE 4242

CMD ["bash", "--login"]
