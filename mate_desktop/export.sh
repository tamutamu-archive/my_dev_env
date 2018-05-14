#!/bin/bash -eu

CURDIR=$(cd $(dirname $0); pwd)


dconf dump / > ./dconf/dconf.dump
