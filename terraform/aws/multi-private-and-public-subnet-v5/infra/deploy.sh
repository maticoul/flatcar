cd infra/
terraform init
terraform  apply --auto-approve
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/infra/ansible/0-inventory.yml /home/ubuntu/infra/ansible/1-install-nodes-kubernetes.yml
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/infra/ansible/0-inventory.yml /home/ubuntu/infra/ansible/2-cluster_etcd.yaml
ANSIBLE_SSH_ARGS="-o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/infra/ansible/0-inventory.yml /home/ubuntu/infra/ansible/3-cluster_k8s.yml