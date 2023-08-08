```bash
$ customize the inventory.ini to match your environment
$ ansible-playbook -i inventory.ini install-nodes-kubernetes.yml
$ ansible-playbook -i inventory.ini Infrastructure.yml
$ ansible-playbook -i inventory.ini cluster_etcd.yml
$ ansible-playbook -i inventory.ini cluster_k8s.yml
$ ansible-playbook -i inventory.ini controller.yml
```