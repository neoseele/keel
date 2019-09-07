#!/bin/bash

usage() { echo "Usage: $0 -r release -a|-d|-c [-f values-xxx.yaml]" 1>&2; exit 1; }

while getopts ":r:adcf:" arg; do
  case $arg in
    r)
      release=${OPTARG}
      ;;
    a)
      action="apply"
      ;;
    d)
      action="delete"
      ;;
    c)
      action="check"
      ;;
    f)
      mod_file=${OPTARG}
      ;;
    *)
      usage
      ;;
  esac
done
shift $((OPTIND-1))

if [ -z "${release}" ]; then
  usage
fi

cmd="helm template . --name ${release}"

if [ -n "${mod_file}" ]; then
  cmd="${cmd} -f ${mod_file}"
fi

cmd="${cmd} | sed 's/RELEASE/${release}/g'"

yaml="$(eval $cmd)"

case $action in
"check")
  echo "${yaml}" | kubectl apply --dry-run -f -
  ;;
"apply")
  echo "${yaml}" | kubectl apply -f -
  ;;
"delete")
  echo "${yaml}" | kubectl delete -f -
  ;;
*)
  echo "${yaml}"
  ;;
esac