FROM centos:centos8

RUN yum -y update
RUN yum -y install flatpak flatpak-builder
RUN yum -y clean all

ENV PATH="/var/lib/flatpak/exports/bin:${PATH}"
ENV PATH="~/.local/share/flatpak/exports/bin:${PATH}"

WORKDIR /root/CS573-Final-Project
COPY README.md ./
COPY flatpaks flatpaks/
COPY provision/install_flatpaks.sh provision/
RUN sed -i 's/sudo //g; s/--user //g' provision/install_flatpaks.sh;

ENTRYPOINT ["/bin/bash"]
