#!/bin/bash
# A useful script to output cert / priv key / chain .pem files to terminal
# 
# Why:
# I found this task quite repetitive every 3 months, this script just outputs
# the generated certificates to the terminal for copy and pasting, a tiny bit 
# more useful than pulling them out seperately, and navigating through them.
# 
# My enviroment:
# OSX El Capitan
# Bash
# 
# Disclaimer:
# Sorry, I can't be held liable for any problems this script may cause to your system,
# even though it's highly unlikely.
#
# Usage: sh output.sh www.domain.com
# -----------------------------------------------------------------------------


if [ ! "`whoami`" = "root" ]
then
    echo "\nMust elevate to the root use before running."
    exit 1
fi

PROG_NAME=$0
DOMAIN_NAME=$1

if [ $# -lt 1 ]
then
  echo "Usage: $PROG_NAME [ww.domain.com]"
  exit 1
fi

CERT=/etc/letsencrypt/live/$DOMAIN_NAME/cert.pem
PK=/etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem
CHAIN=/etc/letsencrypt/live/$DOMAIN_NAME/chain.pem

if [ ! -f $CERT  ] && [ ! -f $PK ] && [ ! -f $CHAIN ];
then
  echo "Error: Could not locate one of the certificate files."
  exit 1
fi

# Output todays date + 90 days.
date -j -v +90d

# Output the cert.pem
sudo cat /etc/letsencrypt/live/$DOMAIN_NAME/cert.pem

# Converting the Private Key to RSA / output
sudo openssl rsa -inform pem -in /etc/letsencrypt/live/$DOMAIN_NAME/privkey.pem -outform pem

# Output the chain.pem
sudo cat /etc/letsencrypt/live/$DOMAIN_NAME/chain.pem

exit 1

