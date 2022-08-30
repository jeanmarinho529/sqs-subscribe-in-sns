locals {
  create_topic        = var.topic_queue.topic != "" ? 1 : 0
  create_queue        = var.topic_queue.queue != "" ? 1 : 0
  create_subscription = lookup(var.topic_queue, "subscribe", true) && var.topic_queue.queue != "" ? 1 : 0
}

locals {
  prefix_topic_name     = "${var.team}_${var.prefixes.topic}__${var.topic_queue.topic}"
  prefix_queue_name     = "${var.team}_${var.prefixes.queue}__${var.topic_queue.queue}"
  prefix_dlq_queue_name = "${var.team}-${var.prefixes.queue_dlq}_${var.prefixes.queue}__${var.topic_queue.queue}"
}

locals {
  topic_name     = var.use_prefixes.topic == true ? local.prefix_topic_name : var.topic_queue.topic
  queue_name     = var.use_prefixes.queue == true ? local.prefix_queue_name : var.topic_queue.queue
  queue_dlq_name = var.use_prefixes.queue_dlq == true ? local.prefix_dlq_queue_name : var.topic_queue.queue_dlq
}