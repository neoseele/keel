#!/bin/bash

usage() { echo "Usage: $0 -r release_name -d|-a|-c values-xxx.yaml" 1>&2; exit 1; }

while getopts ":r:d:a:c:" arg; do
  case $arg in
    r)
      r=${OPTARG}
      ;;
    d)
      d=${OPTARG}
      ;;
    a)
      a=${OPTARG}
      ;;
    c)
      c=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${r}" ]; then
  usage
fi

if [ -n "${d}" ]; then
  helm template . --name ${r} -f ${d} | sed "s/RELEASE/${r}/g"
elif [ -n "${a}" ]; then
  helm template . --name ${r} -f ${a} | sed "s/RELEASE/${r}/g" | kubectl apply -f -
elif [ -n "${c}" ]; then
  helm template . --name ${r} -f ${c} | sed "s/RELEASE/${r}/g" | kubectl delete -f -
else
  usage
fi
