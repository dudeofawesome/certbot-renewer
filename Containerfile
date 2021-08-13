FROM docker.io/library/python:3.8
LABEL org.opencontainers.image.authors="Louis Orleans <louis@orleans.io>"
LABEL org.opencontainers.image.description="Manipulate DNS records on various DNS providers in a standardized way"

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
  dnsutils \
  git
RUN python -m pip install -U poetry

RUN git clone https://github.com/dudeofawesome/lexicon --branch patch-1 /src/lexicon
WORKDIR /src/lexicon
RUN poetry install -E full
ENV PATH=/src/lexicon/.venv/bin:$PATH

ENTRYPOINT ["lexicon"]
