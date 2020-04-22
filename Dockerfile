FROM ubuntu:18.04

# We don't want to be asked any questions when
# packages get installed...
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
 && apt-get install -yq \
    libxerces-c-dev \
    qt4-dev-tools \
    freeglut3-dev \
    libmotif-dev \
    tk-dev \
    cmake \
    libxpm-dev \
    libxmu-dev \
    libxi-dev \
    libboost-all-dev \
    libboost-python-dev \
    libxerces-c-dev \
    # Python 3
    python3 \
    python3-pip \
    # Python 2
    #python \
    #python-pip \
    # needed to fetch the tarball
    wget

WORKDIR /opt/geant4

RUN wget http://geant4-data.web.cern.ch/geant4-data/releases/geant4.10.06.p01.tar.gz \
 && tar -zxvf geant4.10.06.p01.tar.gz \
 && mv geant4.10.06.p01 geant4-src \
 && rm geant4.10.06.p01.tar.gz \
 && mkdir geant4-build

# If any package is missing at this point, try
# installing here, before rerunning everything:
#RUN apt-get install -yq wget

WORKDIR /opt/geant4/geant4-build
RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/geant4/geant4-install \
    -DGEANT4_USE_GDML=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    -DGEANT4_INSTALL_DATA=ON \
    -DGEANT4_USE_OPENGL_X11=ON \
    -DGEANT4_USE_XM=ON \
    -DGEANT4_USE_QT=ON \
    -DGEANT4_BUILD_MULTITHREADED=ON \
    ../geant4-src

RUN make -j4

RUN make install
ENV GEANT4_INSTALL=/opt/geant4/geant4-install

WORKDIR /opt/geant4/geant4-g4py-build

RUN cmake \
    -DCMAKE_INSTALL_PREFIX=/opt/geant4/geant4-g4py \
    /opt/geant4/geant4-src/environments/g4py

RUN make -j1
