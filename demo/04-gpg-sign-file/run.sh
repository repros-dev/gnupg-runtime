#!/usr/bin/env bash


PUBLIC_KEY_FILE=data/public.pgp
PRIVATE_KEY_FILE=data/private.asc
MESSAGE_FILE=data/message.txt
MESSAGE_SIGNATURE_FILE=tmp/message.sig

# ------------------------------------------------------------------------------

bash_cell 'import the private key for repro@repros.dev' << END_CELL

# delete contents of the .gnupg directory for this REPRO
gnupg-runtime.purge-keys

# import the private key file
gpg --import --pinentry-mode loopback --passphrase=repro ${PRIVATE_KEY_FILE} 2>&1
echo

# list the gpg keys
gpg --list-keys

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'sign a file using the private key' << END_CELL

rm -f ${MESSAGE_SIGNATURE_FILE}

gpg --detach-sign --local-user repro@repros.dev \
    --pinentry-mode loopback --passphrase=repro \
    --output ${MESSAGE_SIGNATURE_FILE}          \
    --armor ${MESSAGE_FILE} 2>&1

gnupg-runtime.redact-key ${MESSAGE_SIGNATURE_FILE}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'import the public key for repro@repros.dev' << END_CELL

# delete contents of the .gnupg directory for this REPRO
gnupg-runtime.purge-keys

# import the public key file
gpg --import ${PUBLIC_KEY_FILE} 2>&1
echo

# list the gpg keys
gpg --list-keys

# show the public key that was imported
gpg --export --armor repro@repros.dev

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'verify the message and signature using the public key' << END_CELL

gpg -v --verify ${MESSAGE_SIGNATURE_FILE} ${MESSAGE_FILE} 2>&1 | tail -6

END_CELL
