FROM ubuntu:20.04

# We don't want to be asked any questions when packages get installed...
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
 && apt-get install -yqq \
    cmake \
    freeglut3-dev \
    libmotif-dev \
    libxerces-c-dev \
    libxi-dev \
    libxmu-dev \
    libxpm-dev \
    python3 \
    python3-pip \
    qt5-default \
    qttools5-dev-tools \
    tk-dev \
    wget \
 && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /var/cache/

# Compile a custom version of the boost libraries for Python3 support
RUN wget --no-verbose https://dl.bintray.com/boostorg/release/1.72.0/source/boost_1_72_0.tar.gz && \
 tar xzf boost_1_72_0.tar.gz && \
 cd boost_1_72_0 && \
 ln -s /usr/local/include/python3.7m /usr/local/include/python3.7 && \
 ./bootstrap.sh --with-python=$(which python3) && \
 ./b2 install && \
 rm /usr/local/include/python3.7 && \
 ldconfig && \
 cd - && rm -rf *

# Compile Geant4 including the Python environment
RUN wget http://geant4-data.web.cern.ch/geant4-data/releases/geant4.10.06.p02.tar.gz \
 && tar -zxvf geant4.10.06.p02.tar.gz \
 && rm geant4.10.06.p02.tar.gz \
 && mv geant4.10.06.p02 geant4-src \
 && mkdir geant4-build \
 && cd geant4-build \
 && cmake \
    -DCMAKE_INSTALL_PREFIX=/ \
    -DGEANT4_USE_GDML=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DGEANT4_INSTALL_DATA=ON \
    -DGEANT4_USE_OPENGL_X11=ON \
    -DGEANT4_USE_XM=ON \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    -DGEANT4_BUILD_TLS_MODEL=global-dynamic \
    -DGEANT4_USE_PYTHON=ON \
    ../geant4-src \
 && make -j$(nproc) \
 && make install \
 && rm -rf /var/cache/geant4-src /var/cache/geant4-build

ENV PYTHONPATH=$PYTHONPATH:/usr/lib/python3.7/site-packages

WORKDIR /

RUN echo "source /usr/share/Geant4-10.6.2/geant4make/geant4make.sh" > /etc/profile.d/geant4.sh
RUN echo 'export PS1="\[$(tput setaf 4)$(tput bold)[\]geant4@\\h$:\\w]#\[$(tput sgr0) \]"' >> /root/.bash_profile

ENV TERM=xterm-256color
CMD /bin/bash -l
