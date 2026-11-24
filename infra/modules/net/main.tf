resource "aws_lb" "public" {
  subnets                    = ["subnet-a"]
  enable_deletion_protection = true
}
