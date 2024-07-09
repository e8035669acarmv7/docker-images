#!/bin/bash

docker build --rm -t e8035669/linux-anvil-armv7l -f linux-anvil-armv7l/Dockerfile .

docker tag e8035669/linux-anvil-armv7l:latest e8035669/linux-anvil-armv7l:1.0.6

