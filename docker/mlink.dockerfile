FROM gaow/base-notebook:1.0.0

MAINTAINER Diana Cornejo <dmc2245@cumc.columbia.edu>

USER root

## Install dependency tools fastlink from Debian package repo, currently version 4.1P
## And LINKAGE program from our own repo; overwriting packages in LINKAGE with those in FASTLINK when possible

RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 
# Problem using letsencrypt for staten.us and a solution
# https://stackoverflow.com/questions/69401972/refresh-lets-encrypt-root-ca-in-docker-container
RUN sed -i 's/mozilla\/DST_Root_CA_X3.crt/!mozilla\/DST_Root_CA_X3.crt/g' /etc/ca-certificates.conf
RUN update-ca-certificates
RUN echo "deb [trusted=yes] https://statgen.us/deb ./" | tee -a /etc/apt/sources.list.d/statgen.list && \
    apt-get update && \
    apt-get install -y linkage && \
    apt-get -o Dpkg::Options::="--force-overwrite" install -y fastlink fastlink-doc && \
    apt-get clean

# Download scripts and tutorial files
USER jovyan
ARG DUMMY=unknown
RUN curl -fsSL https://statgen.us/files/peds-a.pre -o peds-a.pre
RUN DUMMY=${DUMMY} curl -fsSL https://raw.githubusercontent.com/statgenetics/statgen-courses/master/handout/MLINK.pdf -o MLINK.pdf 
