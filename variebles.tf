variable "topic_queue" {
  type = map(string)
}

variable "team" {
  type = string
}

variable "prefixes" {
  type = object({
    topic     = string
    queue     = string
    queue_dlq = string
  })

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

  default = {
    queue     = true
    queue_dlq = true
    topic     = true
  }
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "topic_tags" {
  type = map(string)
  default = {
    product = "sns"
  }
}

variable "queue_tags" {
  type = map(string)
  default = {
    product = "sqs"
  }
}

variable "queue_actions" {
  type = list(string)
  default = [
    "sqs:SendMessage"
  ]
}

variable "queue_version" {
  type = string
  default = "2008-10-17"
}

variable "topic_version" {
  type = string
  default = "2008-10-17"
}

variable "topic_actions" {
  type = list(string)
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
  type = map(any)
  default = {}
}

variable "topic_police_settings" {
  type = map(any)
  default = {}
}

# variable "queue_settings" {
#   type        = object({
#     name = string
#     nome = optional(string)
#   })
#   description = "subscribe protocol"
# }

# variable "queues_topics" {
#   type = list(map(string))
# }

# variable "sns" {
#   type = string
# }

# variable "sqs" {
#   type = list
# }

# variable "topic_queue" {
#   type = object({
#     topic = string
#     queue = string
#   })
# }

# variable "index" {
#   type = number
# }