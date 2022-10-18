locals {
  name = var.name != null ? var.name : var.product

  create_replication_target_policy = var.replication_source != null

  bucket_policy = var.bucket_policy != null ? var.bucket_policy : data.aws_iam_policy_document.bucket_policy_doc[0].json
}
