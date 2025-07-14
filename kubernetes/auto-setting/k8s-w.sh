#!/usr/bin/env bash

echo ">>>> K8S Node config Start <<<<"

WORKER_NUM=$1
WORKER_IP="192.168.10.10${WORKER_NUM}"

echo "[TASK 1] K8S Controlplane Join"
sed -i "s/NODE_IP_PLACEHOLDER/${WORKER_IP}/g" /tmp/kubeadm-join-worker-config.yaml
kubeadm join --config="/tmp/kubeadm-join-worker-config.yaml" > /dev/null 2>&1

echo ">>>> K8S Node config End <<<<"