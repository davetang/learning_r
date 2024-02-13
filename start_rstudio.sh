#!/usr/bin/env bash

set -euo pipefail

check_depend (){
   tool=$1
   if [[ ! -x $(command -v ${tool}) ]]; then
     >&2 echo Could not find ${tool}
     exit 1
   fi
}

dependencies=(docker)
for tool in ${dependencies[@]}; do
   check_depend ${tool}
done

RVER=4.3.2
PORT=9998
NAME=r_package_test

docker run \
   --name ${NAME} \
   --rm \
   -d \
   -p ${PORT}:8787 \
   -v $(pwd):$(pwd) \
   -w $(pwd) \
   -e PASSWORD=password \
   -e USERID=$(id -u) \
   -e GROUPID=$(id -g) \
   rocker/rstudio:${RVER}

>&2 echo ${NAME} listening on port ${PORT}

exit 0
