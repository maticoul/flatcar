## multi master with external etcd 
```bash
    1 - customize the inventory.ini to match your environment;
    2 - ansible-playbook -i inventory.ini install-nodes-kubernetes.yml;
    3 - ansible-playbook -i inventory.ini Infrastructure.yml;
    4 - ansible-playbook -i inventory.ini cluster_etcd.yml;
    5 - ansible-playbook -i inventory.ini cluster_k8s.yml;
    6 - ansible-playbook -i inventory.ini controller.yml;
```
## multi master internal etcd

    1 - customize the inventory.ini to match your environment;
    2 - ansible-playbook -i inventory.ini install-nodes-kubernetes.yml;
    3 - ansible-playbook -i inventory.ini Infrastructure.yml;
    4 - ansible-playbook -i inventory.ini cluster_k8s.yml;
    5 - ansible-playbook -i inventory.ini controller.yml;




