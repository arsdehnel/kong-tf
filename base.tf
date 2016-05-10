resource "aws_key_pair" "kong-qa" {
  key_name = "kong-qa" 
  public_key = "${var.public_key}"
}