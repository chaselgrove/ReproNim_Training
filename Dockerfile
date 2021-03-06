# Generated by Neurodocker v0.3.1-21-ged92d36.
#
# Thank you for using Neurodocker. If you discover any issues
# or ways to improve this software, please submit an issue or
# pull request on our GitHub repository:
#     https://github.com/kaczmarj/neurodocker
#
# Timestamp: 2017-11-11 16:05:42

FROM neurodebian:stretch-non-free

ARG DEBIAN_FRONTEND=noninteractive

#----------------------------------------------------------
# Install common dependencies and create default entrypoint
#----------------------------------------------------------
ENV LANG="en_US.UTF-8" \
    LC_ALL="C.UTF-8" \
    ND_ENTRYPOINT="/neurodocker/startup.sh"
RUN apt-get update -qq && apt-get install -yq --no-install-recommends  \
    	apt-utils bzip2 ca-certificates curl locales unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && localedef --force --inputfile=en_US --charmap=UTF-8 C.UTF-8 \
    && chmod 777 /opt && chmod a+s /opt \
    && mkdir -p /neurodocker \
    && if [ ! -f "$ND_ENTRYPOINT" ]; then \
         echo '#!/usr/bin/env bash' >> $ND_ENTRYPOINT \
         && echo 'set +x' >> $ND_ENTRYPOINT \
         && echo 'if [ -z "$*" ]; then /usr/bin/env bash; else $*; fi' >> $ND_ENTRYPOINT; \
       fi \
    && chmod -R 777 /neurodocker && chmod a+s /neurodocker
ENTRYPOINT ["/neurodocker/startup.sh"]

RUN apt-get update -qq \
    && apt-get install -y -q --no-install-recommends fsl-core \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add command(s) to entrypoint
RUN sed -i '$isource /etc/fsl/fsl.sh' $ND_ENTRYPOINT

#--------------------------------------
# Save container specifications to JSON
#--------------------------------------
RUN echo '{ \
    \n  "pkg_manager": "apt", \
    \n  "check_urls": false, \
    \n  "instructions": [ \
    \n    [ \
    \n      "base", \
    \n      "neurodebian:stretch-non-free" \
    \n    ], \
    \n    [ \
    \n      "install", \
    \n      [ \
    \n        "fsl-core" \
    \n      ] \
    \n    ], \
    \n    [ \
    \n      "add_to_entrypoint", \
    \n      [ \
    \n        "source /etc/fsl/fsl.sh" \
    \n      ] \
    \n    ] \
    \n  ], \
    \n  "generation_timestamp": "2017-11-11 16:05:42", \
    \n  "neurodocker_version": "0.3.1-21-ged92d36" \
    \n}' > /neurodocker/neurodocker_specs.json

RUN apt-get -y update
RUN apt-get -y install r-base
RUN apt-get -y install git emacs
RUN git clone https://github.com/jgrethe/ReproNim_Training.git

# Add command(s) to entrypoint
RUN sed -i '$i/ReproNim_Training/analyze' $ND_ENTRYPOINT

WORKDIR "ReproNim_Training"

