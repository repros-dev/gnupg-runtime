#!/usr/bin/env bash

# ------------------------------------------------------------------------------

bash_cell 'delete gnupg home directory' << 'END_CELL'

# delete contents of the .gnupg directory for this REPRO
gnupg-runtime.purge-keys

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'import a private key' << 'END_CELL'

gpg --import --pinentry-mode loopback --passphrase=repro data/private.asc

# list the gpg keys
gpg --list-keys

# show the public key that was bundled with the private key
gpg --export --armor repro@repros.dev

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'encrypt the message in a text file' << 'END_CELL'

ENCRYPTED_FILE=products/message.asc
rm -f ${ENCRYPTED_FILE}

gpg --encrypt --always-trust --armor --recipient repro@repros.dev --output ${ENCRYPTED_FILE} data/message.txt

cat ${ENCRYPTED_FILE}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'decrypt the message' << 'END_CELL'

gpg --decrypt --pinentry-mode loopback --passphrase=repro products/message.asc

END_CELL
