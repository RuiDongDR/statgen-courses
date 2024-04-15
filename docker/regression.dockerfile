FROM gaow/base-notebook:1.0.0

MAINTAINER Diana Cornejo <dmc2245@cumc.columbia.edu>

# Install dependency tools and install data-set

USER root

RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 
# Problem using letsencrypt for staten.us and a solution
# https://stackoverflow.com/questions/69401972/refresh-lets-encrypt-root-ca-in-docker-container
RUN sed -i 's/mozilla\/DST_Root_CA_X3.crt/!mozilla\/DST_Root_CA_X3.crt/g' /etc/ca-certificates.conf
RUN update-ca-certificates
RUN echo "deb [trusted=yes] https://statgen.us/deb ./" | tee -a /etc/apt/sources.list.d/statgen.list && \
apt-get update && \
    apt-get install -y regression-tutorial && \
    apt-get clean && mv /home/shared/* /home/jovyan && rm -rf /home/shared && chown jovyan.users -R /home/jovyan/*

# Download notebook script and clean out output

USER jovyan

ARG DUMMY=unknown

RUN DUMMY=${DUMMY} curl -fsSL https://raw.githubusercontent.com/statgenetics/statgen-courses/master/handout/regression.docx -o regression.docx && \
                   curl -fsSL https://raw.githubusercontent.com/statgenetics/statgen-courses/master/handout/regression.pdf -o regression.pdf && \
                   curl -fsSL https://raw.githubusercontent.com/statgenetics/statgen-courses/master/code/regression.R -o regression.R
