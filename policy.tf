resource "aws_sns_topic_policy" "this" {
  count = local.create_topic
  arn = aws_sns_topic.this[0].arn

  policy = data.aws_iam_policy_document.sns_topic_policy.json
  depends_on = [aws_sns_topic.this]
}

data "aws_iam_policy_document" "sns_topic_policy" {
  version = lookup(var.topic_police_settings, "version", "2008-10-17")
  policy_id = lookup(var.topic_police_settings, "policy_id", "__default_policy_ID")


  statement {
    actions = lookup(var.topic_police_settings, "policy_id", var.topic_actions)

    effect = lookup(var.topic_police_settings, "effect", "Allow")

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sns_topic.this[0].arn
    ]

    sid = lookup(var.topic_police_settings, "sid", "__default_statement_ID")
  }
}

resource "aws_sqs_queue_policy" "this" {
  count = local.create_topic * local.create_queue
  queue_url = aws_sqs_queue.this[0].id

  policy = data.aws_iam_policy_document.sqs_queue_policy.json
  depends_on = [aws_sqs_queue.this, aws_sns_topic.this]
}

data "aws_iam_policy_document" "sqs_queue_policy" {
  version = lookup(var.queue_police_settings, "version", "2008-10-17")

  statement {
    actions = lookup(var.queue_police_settings, "actions", var.queue_actions)

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"

      values = [
        aws_sns_topic.this[0].arn
      ]
    }

    effect = lookup(var.queue_police_settings, "effect", "Allow")

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [aws_sns_topic.this[0].arn]

    sid = lookup(var.queue_police_settings, "sid", "AllowEventsToSQS")
  }
}
