## helm 으로 flannel 제거
helm uninstall -n kube-flannel flannel
helm list -A
kubectl get all -n kube-flannel
kubectl delete ns kube-flannel

## vnic 제거
ip link del flannel.1
ip link del cni0

for i in w1 w2 ; do echo ">> node : k8s-$i <<"; sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@k8s-$i sudo ip link del flannel.1 ; echo; done
for i in w1 w2 ; do echo ">> node : k8s-$i <<"; sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@k8s-$i sudo ip link del cni0 ; echo; done

## 제거 확인
ip -c link
for i in w1 w2 ; do echo ">> node : k8s-$i <<"; sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@k8s-$i ip -c link ; echo; done

brctl show
for i in w1 w2 ; do echo ">> node : k8s-$i <<"; sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@k8s-$i brctl show ; echo; done

ip -c route
for i in w1 w2 ; do echo ">> node : k8s-$i <<"; sshpass -p 'vagrant' ssh -o StrictHostKeyChecking=no vagrant@k8s-$i ip -c route ; echo; done

## 기존 kube-proxy 제거
kubectl -n kube-system delete ds kube-proxy
kubectl -n kube-system delete cm kube-proxy

iptables-save | grep -v KUBE | grep -v FLANNEL | iptables-restore
iptables-save

sshpass -p 'vagrant' ssh vagrant@k8s-w1 "sudo iptables-save | grep -v KUBE | grep -v FLANNEL | sudo iptables-restore"
sshpass -p 'vagrant' ssh vagrant@k8s-w1 sudo iptables-save

sshpass -p 'vagrant' ssh vagrant@k8s-w2 "sudo iptables-save | grep -v KUBE | grep -v FLANNEL | sudo iptables-restore"
sshpass -p 'vagrant' ssh vagrant@k8s-w2 sudo iptables-save

## Cilium 설치 with Helm
helm repo add cilium https://helm.cilium.io/

# 모든 NIC 지정 + bpf.masq=true + NoIptablesRules
helm install cilium cilium/cilium --version 1.17.5 --namespace kube-system \
    --set k8sServiceHost=192.168.10.100 --set k8sServicePort=6443 \
    --set kubeProxyReplacement=true \
    --set routingMode=native \
    --set autoDirectNodeRoutes=true \
    --set ipam.mode="cluster-pool" \
    --set ipam.operator.clusterPoolIPv4PodCIDRList={"172.20.0.0/16"} \
    --set ipv4NativeRoutingCIDR=172.20.0.0/16 \
    --set endpointRoutes.enabled=true \
    --set installNoConntrackIptablesRules=true \
    --set bpf.masquerade=true \
    --set ipv6.enabled=false

# 확인
helm get values cilium -n kube-system
helm list -A
kubectl get crd
watch -d kubectl get pod -A

kubectl exec -it -n kube-system ds/cilium -c cilium-agent -- cilium-dbg status --verbose

## 노드에서 iptables 확인
iptables -t nat -S
for i in w1 w2 ; do echo ">> node : k8s-$i <<"; sshpass -p 'vagrant' ssh vagrant@k8s-$i sudo iptables -t nat -S ; echo; done

iptables-save
for i in w1 w2 ; do echo ">> node : k8s-$i <<"; sshpass -p 'vagrant' ssh vagrant@k8s-$i sudo iptables-save ; echo; done
