resource "aws_key_pair" "ff" {
  key_name   = var.key_name
  public_key = var.key
}