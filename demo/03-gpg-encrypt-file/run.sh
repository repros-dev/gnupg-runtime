#!/usr/bin/env bash

PUBLIC_KEY_FILE=data/public.gpg
PRIVATE_KEY_FILE=data/private.asc
CLEAR_MESSAGE_FILE=data/message.txt
ENCRYPTED_MESSAGE_FILE=tmp/message.asc

# ------------------------------------------------------------------------------

bash_cell 'import the public key for repro@repros.dev' << END_CELL

# delete contents of the .gnupg directory for this REPRO
gnupg-runtime.purge-keys

# import the private key file
gpg --import ${PUBLIC_KEY_FILE} 2>&1

# list the gpg keys
gpg --list-keys

# show the public key that was imported
gpg --export -a repro@repros.dev

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'encrypt a file using the public key' << END_CELL

rm -f ${ENCRYPTED_MESSAGE_FILE}

gpg --encrypt --always-trust -a --recipient repro@repros.dev -o ${ENCRYPTED_MESSAGE_FILE} ${CLEAR_MESSAGE_FILE} 2>&1

gnupg-runtime.redact-key ${ENCRYPTED_MESSAGE_FILE}

END_CELL


# ------------------------------------------------------------------------------

bash_cell 'import the private key for repro@repros.dev' << END_CELL

# import the private key file
gpg --import --pinentry-mode loopback --passphrase=repro ${PRIVATE_KEY_FILE} 2>&1

# list the gpg keys
gpg --list-keys

# show the public key that was bundled in the private key file
gpg --export -a repro@repros.dev

END_CELL


# ------------------------------------------------------------------------------

bash_cell 'decrypt the message using the private key' << END_CELL

gpg --decrypt --pinentry-mode loopback --passphrase=repro ${ENCRYPTED_MESSAGE_FILE} 2>&1

END_CELL
