#!/usr/bin/env bash

kind create cluster --config cluster.yaml

kubectl config set-context data-cluster --cluster=data-cluster

kubectl create namespace cert-manager
kubectl create namespace o11y
kubectl create namespace druid-operator-system
kubectl create namespace druid
kubectl create namespace kafka
kubectl create namespace api

helm repo add jetstack https://charts.jetstack.io
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add open-telemetry https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add datainfra https://charts.datainfra.io

helm repo update

helm upgrade -i kube-prometheus-stack prometheus-community/kube-prometheus-stack -n o11y --values o11y/kube-prometheus-stack.yaml

helm upgrade -i loki grafana/loki-stack -n o11y --values o11y/loki-stack.yaml &

helm upgrade -i tempo grafana/tempo -n o11y --values o11y/tempo.yaml &

helm upgrade -i kafka bitnami/kafka -n kafka --values kafka/kafka.yaml &

helm upgrade -i cluster-druid-operator datainfra/druid-operator -n druid-operator-system

helm upgrade -i cert-manager -n cert-manager --version v1.12.7 jetstack/cert-manager --values common/cert-manager.yaml &
while [[ $( kubectl get pods -n cert-manager -l app=cert-manager -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for cert-manager" && sleep 1; done
while [[ $( kubectl get pods -n cert-manager -l app=cainjector -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for cert-manager cainjector" && sleep 1; done
while [[ $( kubectl get pods -n cert-manager -l app=webhook -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for cert-manager webhook" && sleep 1; done

helm upgrade -i opentelemetry-operator open-telemetry/opentelemetry-operator -n o11y
while [[ $( kubectl get pods -n o11y -l app.kubernetes.io/name=opentelemetry-operator -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for opentelemetry-operator" && sleep 1; done

helm upgrade -i opentelemetry-collector open-telemetry/opentelemetry-collector -n o11y --values o11y/opentelemetry-collector.yaml &

kubectl apply -f o11y/opentelemetry-collector-service-monitor.yaml

kubectl apply -f druid/tiny-zk.yaml
while [[ $(kubectl get pods -n druid -l zk_cluster=tiny-cluster-zk -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do echo "waiting for zookeeper" && sleep 1; done

kubectl apply -f druid/tiny.yaml
kubectl apply -f druid/service-monitor.yaml

kubectl get all -A
