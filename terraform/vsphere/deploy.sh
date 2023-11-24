cd cluster_nodes/
terraform init
terraform  apply --auto-approve
cd cluster_infra/
terraform init
terraform  apply --auto-approve
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/ansible/0-inventory.yml /home/ubuntu/ansible/1-install-nodes-kubernetes.yml
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/ansible/0-inventory.yml /home/ubuntu/ansible/2-cluster_etcd.yaml
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/ansible/0-inventory.yml /home/ubuntu/ansible/3-cluster_k8s.yml