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
Name-Email: repro@repros.org
Passphrase: repro
END_GPG_INPUT

# list the gpg keys
gpg --list-keys | grep uid

END_CELL


