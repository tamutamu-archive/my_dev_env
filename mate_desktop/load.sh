#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)


dconf load / < ./dconf/dconf.dump
