# data-cluster

create a kubernetes cluster using oss and their respective helm charts and the kind cli. includes kube-prometheus-stack, loki-stack, tempo, opentelemetry-operator, opentelemetry-collector, kafka, and druid

### required

+ [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)
+ [helm](https://helm.sh/docs/intro/install/)
+ [kubectl](https://kubernetes.io/docs/tasks/tools/)

## create

```shell
cd local
./build.sh
```

_references_

+ https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
+ https://github.com/grafana/helm-charts/tree/main/charts/loki-stack
+ https://github.com/grafana/helm-charts/tree/main/charts/tempo
+ https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-operator
+ https://github.com/open-telemetry/opentelemetry-helm-charts/tree/main/charts/opentelemetry-collector
+ https://github.com/open-telemetry/opentelemetry-collector/blob/main/receiver
+ https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver
+ https://github.com/open-telemetry/opentelemetry-collector/tree/main/processor
+ https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/processor
+ https://github.com/open-telemetry/opentelemetry-collector/tree/main/exporter
+ https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/exporter 
