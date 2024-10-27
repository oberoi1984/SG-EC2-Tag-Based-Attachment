variable "security_group_id" {
  description = "The security group ID to attach to matching instances"
  type        = string
}

# Optional: Define a variable for tag key and value to make it dynamic
variable "instance_tag_key" {
  description = "The key of the tag for filtering instances"
  type        = string
  default     = "YourTagKey"
}

variable "instance_tag_value" {
  description = "The value of the tag for filtering instances"
  type        = string
  default     = "YourTagValue"
}
