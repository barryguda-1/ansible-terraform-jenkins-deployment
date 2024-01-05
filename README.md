# Setup notes

```
1. Please run the playbook "gen_ssh_key.yaml" , "ansible-playbook ansible_templates/gen_ssh_key.yaml" 
   to generate SSH keypair(on local system) used in TF templates and Ansible for connecting to 
   remote EC2 instances.
   
2. If you still want to initialize directory via "terraform init", then use the "-backend=false" flag,
   like so "terraform init -backend=false"
```

## Run Ansible Playbook
```
ansible-playbook ansible_templates/gen_ssh_key.yaml
```


## Run Terraform Code
```
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform destroy

```