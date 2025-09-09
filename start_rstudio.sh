#!/usr/bin/env bash

set -euo pipefail

source settings.sh

dependencies=(docker)
for tool in ${dependencies[@]}; do
   check_depend ${tool}
done

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
   ${IMAGE}

>&2 echo ${NAME} listening on port ${PORT}

exit 0
