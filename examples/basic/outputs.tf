output "bucket_policy" {
  description = "JSON value of the bucket policy."
  value       = module.s3_bucket_policy.bucket_policy
}

output "bucket_name" {
  description = "Name of the bucket."
  value       = module.s3.name
}
