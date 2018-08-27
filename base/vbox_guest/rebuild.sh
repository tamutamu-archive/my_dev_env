#!/bin/bash

find /opt -name 'VBoxGuestAdditions-*' | xargs -I{} bash -c 'sudo {}/init/vboxadd setup'

