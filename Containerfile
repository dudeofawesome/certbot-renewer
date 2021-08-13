FROM python:3.8
LABEL org.opencontainers.image.authors="Louis Orleans <louis@orleans.io>"
LABEL org.opencontainers.image.description="Manipulate DNS records on various DNS providers in a standardized way"

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install dnsutils
RUN pip install dns-lexicon[full]

ENTRYPOINT ["lexicon"]
