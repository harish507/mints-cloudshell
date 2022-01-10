curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
sleep 60
sudo apt-get install curl
sleep 60
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF
sleep 60
sudo apt-get update
sleep 60
sudo apt-get install -y kubelet kubeadm kubectl
sleep 60
sudo apt-mark hold kubelet kubeadm kubectl
sleep 60
sudo swapoff -a
sudo hostnamectl set-hostname master-node
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
