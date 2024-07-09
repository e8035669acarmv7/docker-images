#!/bin/bash

version='8.2.4'
build='1.fc40'
arch='arm'
curl -sL \
    "https://kojipkgs.fedoraproject.org/packages/qemu/${version}/${build}/x86_64/qemu-user-static-${arch/ppc64le/ppc}-${version}-${build}.x86_64.rpm" |
    bsdtar -xf- --strip-components=3 ./usr/bin/qemu-${arch}-static

