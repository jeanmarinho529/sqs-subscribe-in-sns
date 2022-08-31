resource "aws_sns_topic" "this" {
  count = local.create_topic
  name  = local.topic_name

  tags = merge(var.tags, var.topic_tags)
}

resource "aws_sqs_queue" "this" {
  count = local.create_queue
  name  = local.queue_name

  delay_seconds             = lookup(var.queue_settings, "delay_seconds", 0)
  max_message_size          = lookup(var.queue_settings, "max_message_size", 86400)            # 4 days
  message_retention_seconds = lookup(var.queue_settings, "message_retention_seconds", 1209600) # 262 KB
  receive_wait_time_seconds = lookup(var.queue_settings, "receive_wait_time_seconds", 10)

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = lookup(var.queue_settings, "max_receive_count", 10)
  })

  tags = merge(var.tags, var.queue_tags)

  depends_on = [aws_sqs_queue.dlq]
}

resource "aws_sqs_queue" "dlq" {
  count = local.create_queue
  name  = local.prefix_dlq_queue_name

  delay_seconds             = lookup(var.queue_settings, "delay_seconds", 0)
  max_message_size          = lookup(var.queue_settings, "max_message_size", 262144)           # 14 days
  message_retention_seconds = lookup(var.queue_settings, "message_retention_seconds", 1209600) # 262 KB
  receive_wait_time_seconds = lookup(var.queue_settings, "receive_wait_time_seconds", 10)

  tags = merge(var.tags, var.queue_tags)
}

resource "aws_sns_topic_subscription" "this" {
  count     = local.create_subscription
  protocol  = "sqs"
  topic_arn = aws_sns_topic.this[0].arn
  endpoint  = aws_sqs_queue.this[0].arn

  depends_on = [aws_sqs_queue.this, aws_sns_topic.this]
}