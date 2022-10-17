variable "name" {
  description = "Name of the s3 bucket this policy is to apply to. If null, will default to product."
  default     = null
  type        = string
}

variable "bucket_policy" {
  description = "Policy to apply to the bucket. If null, one will be guessed based on other variables."
  default     = null
  type        = string
}

variable "force_tls" {
  description = "Deny HTTP requests that are made to the bucket without TLS."
  default     = true
  type        = bool
}

variable "replication_source" {
  description = "The account number and role for the source bucket in a replication configuration."
  default     = null
  type = object({
    account_id = string
    role       = string
  })
}

variable "allow_anonymous_vpce_access" {
  description = "Create bucket policy that allows anonymous VPCE access."
  default     = false
  type        = bool
}

variable "vpce" {
  description = "Name of the VPC endpoint that should have access to this bucket. Only used when `allow_anonymous_vpce_access` is true."
  default     = null
  type        = string
}
