#!/usr/bin/env bash

# ------------------------------------------------------------------------------

bash_cell 'delete gnupg home directory' << 'END_CELL'

# delete contents of the .gnupg directory for this REPRO
gnupg-runtime.purge-keys

# show that the gnupg home directory is now empty
tree -a ${GNUPGHOME}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'delete gnupg home directory' << 'END_CELL'

# list the gpg keys to force creation of the gpg home directory
gpg --list-keys 2>&1

# show that the default keyring and trust database were created
echo
tree -a ${GNUPGHOME}

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'generate a key' << 'END_CELL'

gpg --batch --generate-key << END_GPG_INPUT
Key-Type: RSA
Key-Length: 1024
Name-Real: repro user
Name-Email: repro@repros.dev
Passphrase: repro
END_GPG_INPUT

# list the gpg keys
gpg --list-keys | grep uid

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'export the public key' << 'END_CELL'

PUBLIC_KEY_FILE=tmp/public.pgp
rm -f ${PUBLIC_KEY_FILE}
gpg --output ${PUBLIC_KEY_FILE} --export --armor repro@repros.dev

head -n +1 ${PUBLIC_KEY_FILE}
head -n -1 ${PUBLIC_KEY_FILE} | tail -n +2 | sed 's/./x/g'
tail -n  1 ${PUBLIC_KEY_FILE}

END_CELL


# ------------------------------------------------------------------------------

bash_cell 'export the private key' << 'END_CELL'

PRIVATE_KEY_FILE=tmp/private.asc
rm -f ${PRIVATE_KEY_FILE}
gpg --export-secret-key --pinentry-mode loopback --armor --passphrase=repro > ${PRIVATE_KEY_FILE}

head -n +1 ${PRIVATE_KEY_FILE}
head -n -1 ${PRIVATE_KEY_FILE} | tail -n +2 | sed 's/./x/g'
tail -n  1 ${PRIVATE_KEY_FILE}

END_CELL

