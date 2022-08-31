variable "topic_queue" {
  type        = map(string)
  description = "value"
}

variable "team" {
  type        = string
  description = "name of the team that owns the resource"
}

variable "prefixes" {
  type = object({
    topic     = string
    queue     = string
    queue_dlq = string
  })

  description = "prefixes to create the resource name"

  default = {
    queue     = "prefix_queue"
    queue_dlq = "dead"
    topic     = "prefix_topic"
  }
}

variable "use_prefixes" {
  type = object({
    topic     = bool
    queue     = bool
    queue_dlq = bool
  })

  description = "use prefix in resource name"

  default = {
    queue     = true
    queue_dlq = true
    topic     = true
  }
}

variable "tags" {
  type        = map(string)
  description = "tags"
  default     = {}
}

variable "topic_tags" {
  type        = map(string)
  description = "topic tags"
  default = {
    product = "sns"
  }
}

variable "queue_tags" {
  type        = map(string)
  description = "queue tags"
  default = {
    product = "sqs"
  }
}

variable "queue_actions" {
  type        = list(string)
  description = "queue actions"
  default = [
    "sqs:SendMessage"
  ]
}

variable "topic_actions" {
  type        = list(string)
  description = "topic actions"
  default = [
    "SNS:Subscribe",
    "SNS:SetTopicAttributes",
    "SNS:RemovePermission",
    "SNS:Receive",
    "SNS:Publish",
    "SNS:ListSubscriptionsByTopic",
    "SNS:GetTopicAttributes",
    "SNS:DeleteTopic",
    "SNS:AddPermission",
  ]
}

variable "queue_police_settings" {
  type        = map(any)
  description = "queue police settings"
  default     = {}
}

variable "topic_police_settings" {
  type        = map(any)
  description = "topic police settings"
  default     = {}
}

variable "account_id" {
  type        = string
  description = "account id"
}