output "bucket_policy" {
  description = "JSON value of the bucket policy."
  value       = aws_s3_bucket_policy.bucket_policy.policy
}
