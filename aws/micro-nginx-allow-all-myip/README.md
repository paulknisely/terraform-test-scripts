# Terraform AWS micro instance with nginx

A terraform script that will set up an nginx instance that is only accessible from the IP it's ran from. This is not meant for a production environment.

### Prerequisites

This assumes you have Terraform v0.13.0 installed.

### Installing

Create a ssh key by running

```
ssh-keygen
```

and name the key "terraform"

Once you have your key in place, copy the main.tf file and run

```
terraform init
```

and then run

```
terraform plan
```

If everything appears to look correct, run

```
terraform apply
```

### Current issues

The "allow_all" security group doesn't allow for ssh access until running "terraform apply" for a second time
