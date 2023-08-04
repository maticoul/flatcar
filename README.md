## 1- Terraform

```bash
$ export TF_VAR_provider_vsphere_user='username'
$ export TF_VAR_provider_vsphere_password='password'
$ export TF_VAR_provider_vsphere_host='x.x.x.x'
```
### cluster_infra

```bash
$ cd terraform/cluster_infra
$ terraform init
$ terraform plan
$ terraform apply
```
### cluster_nodes

```bash
$ cd terraform/cluster_nodes
$ terraform init
$ terraform plan
$ terraform apply
```


## 2- Ansible

### multi master with external etcd 
```bash
    $ customize the inventory.ini to match your environment
    $ ansible-playbook -i inventory.ini install-nodes-kubernetes.yml
    $ ansible-playbook -i inventory.ini Infrastructure.yml
    $ ansible-playbook -i inventory.ini cluster_etcd.yml
    $ ansible-playbook -i inventory.ini cluster_k8s.yml
    $ ansible-playbook -i inventory.ini controller.yml
```
### multi master internal etcd
```bash
    $ customize the inventory.ini to match your environment;
    $ ansible-playbook -i inventory.ini install-nodes-kubernetes.yml;
    $ ansible-playbook -i inventory.ini Infrastructure.yml;
    $ ansible-playbook -i inventory.ini cluster_k8s.yml;
    $ ansible-playbook -i inventory.ini controller.yml;
```





