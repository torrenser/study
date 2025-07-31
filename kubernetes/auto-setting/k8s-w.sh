#!/usr/bin/env bash

echo ">>>> K8S Node config Start <<<<"


echo "[TASK 1] K8S Controlplane Join"
WORKER_IP=$(ip -4 addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
sed -i "s/NODE_IP_PLACEHOLDER/${WORKER_IP}/g" /tmp/kubeadm-join-worker-config.yaml
kubeadm join --config="/tmp/kubeadm-join-worker-config.yaml" > /dev/null 2>&1

echo ">>>> K8S Node config End <<<<"