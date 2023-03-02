#!/usr/bin/env bash

# paths to data files
COMMON=../common

# ------------------------------------------------------------------------------

bash_cell 'show gnupg version' << END_CELL

gpg --version

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'show gnupg help' << END_CELL

gpg --help

END_CELL

# ------------------------------------------------------------------------------

bash_cell 'show all gnupg options' << END_CELL

gpg --dump-options

END_CELL
