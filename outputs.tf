output "ec2_instance_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = [
    aws_instance.nginx_server.public_ip,
    aws_instance.apache_server.public_ip
  ]
}

output "subnet_cidr_blocks" {
  value = aws_subnet.example_subnet.*.cidr_block
}

output "lb_hostname_example" {
  value = aws_lb.example_lb.dns_name
}
