#!/bin/bash
cd $(dirname "$(readlink -f $0)")
docker build -t wikitolearn/websrv:0.14.7 .
