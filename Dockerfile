#################################
# Dockerfile to Build Jupyter-Casa image
# Based on Ubuntu:16.06
#################################

FROM ubuntu:16.04
MAINTAINER Dean Gracey
RUN apt-get update && apt-get install -y \
    apt-utils \
    libsm6 \
    libx11.6 \
    libxext6 \
    libxml2 \
    libglib2.0-0 \
    libfreetype6 \
    libxi6 \
    libxrender1 \
    libxrandr2 \
    libxfixes3 \
    libxcursor1 \
    libxinerama1 \
    libfontconfig1 \
    libgl1-mesa-glx \
    libxft2 \
    libkrb5-3 \
    libgssapi-krb5-2 \
    libsqlite3.0 \
    libdbus-1.3 \
    wget \
    bzip2 -y
RUN wget https://repo.continuum.io/archive/Anaconda2-4.3.0-Linux-x86_64.sh && bash Anaconda2-4.3.0-Linux-x86_64.sh -b -p $HOME/anaconda
RUN echo 'export PATH="/root/anaconda/bin:$PATH"' >> /root/.bashrc
RUN wget http://casa.nrao.edu/download/distro/linux/release/el7/casa-release-4.7.1-el7.tar.gz && tar -xzvf casa-release-4.7.1-el7.tar.gz
RUN echo 'export PATH="/casa-release-4.7.1-el7/bin:$PATH"' >> /root/.bashrc
RUN mkdir /opt/notebooks
ADD *.ipynb /opt/notebooks
ADD *.tar.gz /opt/notebooks
CMD ["/bin/bash"]
RUN /root/anaconda/bin/pip install drive-casa
RUN rm -r Anaconda2-4.3.0-Linux-x86_64.sh
RUN rm -r casa-release-4.7.1-el7.tar.gz
 
#######Installation end##########
#EXPOSE 8080
#CMD ["--port 8080"]
