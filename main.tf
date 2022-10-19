data "aws_iam_policy_document" "bucket_policy_doc" {
  count = var.bucket_policy == null ? 1 : 0
  dynamic "statement" {
    for_each = var.allow_anonymous_vpce_access ? [var.allow_anonymous_vpce_access] : []
    content {
      actions = [
        "s3:GetObject",
      ]
      resources = ["arn:aws:s3:::${local.name}/*"]
      condition {
        test     = "StringEquals"
        variable = "aws:sourceVpce"
        values   = [var.vpce]
      }
      principals {
        type        = "*"
        identifiers = ["*"]
      }
    }
  }
  dynamic "statement" {
    for_each = local.create_replication_target_policy ? [local.create_replication_target_policy] : []
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.replication_source.account_id}:role/${var.replication_source.role}"]
      }
      actions = [
        "s3:ReplicateDelete",
        "s3:ReplicateObject",
      ]
      resources = ["arn:aws:s3:::${local.name}/*"]
    }
  }
  dynamic "statement" {
    for_each = local.create_replication_target_policy ? [local.create_replication_target_policy] : []
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.replication_source.account_id}:role/${var.replication_source.role}"]
      }
      actions = [
        "s3:List*",
        "s3:GetBucketVersioning",
        "s3:PutBucketVersioning"
      ]
      resources = ["arn:aws:s3:::${local.name}"]
    }
  }
  dynamic "statement" {
    for_each = local.create_replication_target_policy ? [local.create_replication_target_policy] : []
    content {
      principals {
        type        = "AWS"
        identifiers = ["arn:aws:iam::${var.replication_source.account_id}:role/${var.replication_source.role}"]
      }
      actions = [
        "s3:ObjectOwnerOverrideToBucketOwner"
      ]
      resources = ["arn:aws:s3:::${local.name}/*"]
    }
  }
  dynamic "statement" {
    for_each = var.force_tls ? [var.force_tls] : []
    content {
      effect = "Deny"
      principals {
        type        = "*"
        identifiers = ["*"]
      }
      actions = ["s3:*"]
      resources = [
        "arn:aws:s3:::${local.name}",
        "arn:aws:s3:::${local.name}/*",
      ]
      condition {
        test     = "Bool"
        variable = "aws:SecureTransport"
        values   = ["false"]
      }
    }
  }
  dynamic "statement" {
    for_each = var.cloudfront_oac_access_statements
    content {
      actions   = ["s3:GetObject"]
      resources = ["arn:aws:s3:::${local.name}/${statement.value.path}"]
      principals {
        type        = "Service"
        identifiers = ["cloudfront.amazonaws.com"]
      }
      condition {
        test     = "StringEquals"
        variable = "aws:SourceArn"
        values   = [statement.value.cloudfront_arn]
      }
    }
  }
  source_policy_documents   = var.source_policy_documents
  override_policy_documents = var.override_policy_documents
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = local.name
  policy = local.bucket_policy
}
