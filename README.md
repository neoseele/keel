# keel

A k8s worload similation toolkit

## Prerequesites

- add `keel_run` function to your shell profile

`keel_run` is a wrapper funciton that runs `helm` to generate/verify/deploy/remove k8s resouces.

> `keel_run` is used extensively in this repo

```sh
keel_run() {
  [ -n "$ZSH_VERSION" ] && FUNCNAME=${funcstack[1]}

  local usage="Usage: $FUNCNAME -r release [-n namespace][-a|-d|-v] [-f /path/to/values-xxx.yaml]"

  while getopts ":r:n:advf:" arg; do
    case $arg in
      r) local release=${OPTARG} ;;
      n) local namespace=${OPTARG} ;;
      a) local action="apply" ;;
      d) local action="delete" ;;
      v) local action="check" ;;
      f) local mod_file=${OPTARG} ;;
      *)
        echo $usage
        return 1
        ;;
    esac
  done
  shift $((OPTIND-1))

  local namespace=${namespace:-default}

  if [ ! -f "./Chart.yaml" ]; then
    echo "`pwd` is not a helm chart directory"
    return 1
  fi

  if [ -z "${release}" ]; then
    echo $usage
    return 1
  fi

  local cmd="helm template . --name ${release} --namespace ${namespace}"

  if [ -n "${mod_file}" ]; then
    cmd="${cmd} -f ${mod_file}"
  fi

  cmd="${cmd} ${@} | sed 's/RELEASE/${release}/g'"
  # echo "cmd: ${cmd}"

  local yaml="$(eval $cmd)"

  case $action in
  "check") echo "${yaml}" | kubectl apply --dry-run -f - ;;
  "apply") echo "${yaml}" | kubectl apply -f - ;;
  "delete") echo "${yaml}" | kubectl delete -f - ;;
  *) echo "${yaml}" ;;
  esac
}
```

- `keel_run` usage

```sh
cd charts/tiddles
```

```sh
## generate the YAML only
keel_run -r dev

## dry-run
keel_run -r dev -v

## deploy
keel_run -r dev -a

## clean up
keel_run -r dev -d
```

*`-f [additional_values_yaml]` can be used to customize the default [`values.yaml`](https://helm.sh/docs/chart_template_guide/#charts)*

> modifying the default `values.yaml` is discouraged

```sh
# deploy `tiddles` with istio in a new `istio-workload` namespace
keel_run -r dev -f examples/values-istio.yaml -n istio-workload -a
```
