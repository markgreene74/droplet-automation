variable "do_token" {
  type        = string
  description = "digital ocean token"
  sensitive   = true
}
variable "pvt_key" {
  type        = string
  description = "path to the private key"
  sensitive   = true
}
variable "pub_key" {
  type        = string
  description = "path to the public key"
  sensitive   = true
}
