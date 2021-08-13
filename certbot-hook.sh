#!/usr/bin/env bash

set -euf -o pipefail

# ************** USAGE **************
#
# This is an example hook that can be used with Certbot.
#
# Example usage (with certbot-auto and this hook file saved in /root/):
#
#   sudo ./certbot-auto -d example.org -d www.example.org -a manual -i nginx --preferred-challenges dns \
#   --manual-auth-hook "/root/certbot.default.sh auth" --manual-cleanup-hook "/root/certbot.default.sh cleanup"
#
# This hook requires configuration, continue reading.
#
# ************** CONFIGURATION **************
#
# Please configure lexicon.yml with the necessary credentials found here:
# https://dns-lexicon.readthedocs.io/en/latest/configuration_reference.html.
#
# PROVIDER_UPDATE_DELAY:
#   How many seconds to wait after updating your DNS records. This may be required,
#   depending on how slow your DNS host is to begin serving new DNS records after updating
#   them via the API. 30 seconds is a safe default, but some providers can be very slow
#   (e.g. Linode, Dreamhost).
#
#   Defaults to 30 seconds.
#
PROVIDER_UPDATE_DELAY=300

# To be invoked via Certbot's --manual-auth-hook
function auth {
  echo "Create _acme-challenge.${CERTBOT_DOMAIN}=${CERTBOT_VALIDATION}"

  docker run \
    --name lexicon \
    --interactive --rm \
    --volume "${PWD}:/cwd/:ro" \
    dudeofawesome/lexicon \
      --config-dir /cwd/ \
      auto create "${CERTBOT_DOMAIN}" TXT \
      --name "_acme-challenge.${CERTBOT_DOMAIN}" \
      --content "${CERTBOT_VALIDATION}"

  sleep "${PROVIDER_UPDATE_DELAY}"
}

# To be invoked via Certbot's --manual-cleanup-hook
function cleanup {
  docker run \
    --name lexicon \
    --interactive --rm \
    --volume "${PWD}:/cwd/:ro" \
    dudeofawesome/lexicon \
      --config-dir /cwd/ \
      auto delete "${CERTBOT_DOMAIN}" TXT \
      --name "_acme-challenge.${CERTBOT_DOMAIN}" \
      --content "${CERTBOT_VALIDATION}"
}

HANDLER=$1; shift;
if [ -n "$(type -t $HANDLER)" ] && [ "$(type -t $HANDLER)" = function ]; then
  $HANDLER "$@"
fi

