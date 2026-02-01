resource "aws_s3_bucket" "stride_documents" {
  bucket = "stride-documents"
}

resource "aws_s3_bucket_policy" "stride_documents_policy" {
  bucket = aws_s3_bucket.stride_documents.id
  policy = data.aws_iam_policy_document.stride_documents_policy.json
}

data "aws_iam_policy_document" "stride_documents_policy" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::943818144040:root"]
    }
    
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
    ]
    
    resources = [
      aws_s3_bucket.stride_documents.arn,
      "${aws_s3_bucket.stride_documents.arn}/*",
    ]
  }
}