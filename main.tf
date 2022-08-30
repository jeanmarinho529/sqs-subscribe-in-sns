resource "aws_sns_topic" "this" {
  count = local.create_topic
  name  = local.topic_name

  tags = merge(var.tags, var.topic_tags)
}

resource "aws_sqs_queue" "this" {
  count = local.create_queue
  name  = local.queue_name

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = 10
  })

  tags = merge(var.tags, var.queue_tags)

  depends_on = [aws_sqs_queue.dlq]
}

resource "aws_sqs_queue" "dlq" {
  count = local.create_queue
  name  = local.prefix_dlq_queue_name
  tags = merge(var.tags, var.queue_tags)
}

resource "aws_sns_topic_subscription" "this" {
  count     = local.create_subscription
  protocol  = "sqs"
  topic_arn = aws_sns_topic.this[0].arn
  endpoint  = aws_sqs_queue.this[0].arn

  depends_on = [aws_sqs_queue.this, aws_sns_topic.this]
}