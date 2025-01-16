# KMS key

data "aws_caller_identity" "current" {}
resource "aws_kms_key" "yan_s3_kms" {
  description             = "An example symmetric encryption KMS key"
  enable_key_rotation     = true
  deletion_window_in_days = 20
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow administration of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform"
        },
        Action = [
          "kms:ReplicateKey",
          "kms:Create*",
          "kms:Describe*",
          "kms:Enable*",
          "kms:List*",
          "kms:Put*",
          "kms:Update*",
          "kms:Revoke*",
          "kms:Disable*",
          "kms:Get*",
          "kms:Delete*",
          "kms:ScheduleKeyDeletion",
          "kms:CancelKeyDeletion"
        ],
        Resource = "*"
      },
      {
        Sid    = "Allow use of the key"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/terraform"
        },
        Action = [
          "kms:DescribeKey",
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey",
          "kms:GenerateDataKeyWithoutPlaintext"
        ],
        Resource = "*"
      }
    ]
  })
}

# vpc
resource "aws_vpc" "terraform-vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "terrafor-vpc"
  }  
}

# internet gateway
resource "aws_internet_gateway" "terraform-gw" {
  vpc_id = aws_vpc.terraform-vpc.id

  tags = {
    Name = "terrafor-gw"
  }
}

# route table
resource "aws_route_table" "terraform-public-rt" {
  vpc_id = aws_vpc.terraform-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform-gw.id
  }

  tags = {
    Name = "terraform-public-rt"
  }
}


# add 1 subnet to the route table
resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.terraform-vpc.id
  cidr_block = var.subnet1_cidr

  tags = {
    Name = "public-subnet1"
  }
}

resource "aws_route_table_association" "subnet1_association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.terraform-public-rt.id
}