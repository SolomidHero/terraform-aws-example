# Terraform-aws nginx+apache example

Creates 1 vpc (with 1 security group, 2 subnets), 2 instances (1st with nginx, 2nd with apache for both of subnets), 1 load balancer (which chooses of either services).

Start with (also you can do intermediate plan):

```bash
terraform init
terraform apply
```