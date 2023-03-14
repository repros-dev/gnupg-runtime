#!/usr/bin/env bash


PRIVATE_KEY_FILE=data/private.asc
CLEAR_MESSAGE_FILE=data/message.txt
ENCRYPTED_MESSAGE_FILE=products/message.asc


# ------------------------------------------------------------------------------

bash_cell 'delete gnupg home directory' << END_CELL

# delete contents of the .gnupg directory for this REPRO
gnupg-runtime.purge-keys

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'import a private key and bundled public key' << END_CELL

# import the private key file
gpg --import --pinentry-mode loopback --passphrase=repro ${PRIVATE_KEY_FILE}

# list the gpg keys
gpg --list-keys

# show the public key that was bundled in the private key file
gpg --export --armor repro@repros.dev

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'encrypt the message in a text file using the public key for repro@repros.dev' << END_CELL

rm -f ${ENCRYPTED_MESSAGE_FILE}

gpg --encrypt --always-trust --armor --recipient repro@repros.dev --output ${ENCRYPTED_MESSAGE_FILE} ${CLEAR_MESSAGE_FILE}

cat ${ENCRYPTED_MESSAGE_FILE}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'decrypt the message using the private key for repro@repros.dev' << END_CELL

gpg --decrypt --pinentry-mode loopback --passphrase=repro ${ENCRYPTED_MESSAGE_FILE}

END_CELL
