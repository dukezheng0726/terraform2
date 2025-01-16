output "kms_key_arn" {
    value = aws_kms_key.yan_s3_kms.arn
}

output "vpc_id" {
    value = aws_vpc.terraform-vpc.id
}

output "subnet_id" {
    value = aws_subnet.public-subnet1.id
}

output "route_table_id" {
    value = aws_route_table.terraform-public-rt.id
}