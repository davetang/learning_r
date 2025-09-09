#!/usr/bin/env bash

set -euo pipefail

source settings.sh

num_param=1

usage(){
   echo "Usage: $0 <file.Rmd> [outfile.md]"
   exit 1
}

if [[ $# -lt ${num_param} ]]; then
   usage
fi

infile=$1
if [[ ! -e ${infile} ]]; then
   >&2 echo ${infile} does not exist
   exit 1
fi

if [[ ! ${infile} =~ \.Rmd$ ]]; then
   >&2 echo ${infile} does not have a .Rmd extension
   exit 1
fi

outfile=$(basename ${infile} .Rmd).md
if [[ $# -ge 2 ]]; then
   outfile=$2
fi

dependencies=(docker)
for tool in ${dependencies[@]}; do
   check_depend ${tool}
done

now(){
   date '+%Y/%m/%d %H:%M:%S'
}

SECONDS=0

>&2 printf "[ %s %s ] Start job\n\n" $(now)

PACKAGES=${HOME}/r_packages_${RVER}

if [[ ! -d ${PACKAGES} ]]; then
   mkdir ${PACKAGES}
fi

docker run \
   --rm \
   -v ${PACKAGES}:/packages \
   -v $(pwd):$(pwd) \
   -w $(pwd) \
   -u $(id -u):$(id -g) \
   ${IMAGE} \
   Rscript -e ".libPaths('/packages'); rmarkdown::render('${infile}', output_file = '${outfile}')"

>&2 printf "\n[ %s %s ] Work complete\n" $(now)

duration=$SECONDS
>&2 echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."
exit 0
