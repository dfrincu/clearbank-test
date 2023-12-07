variable "test" {
  description = "The Azure Service Bus configuration for the 'test' environment"
  type = map(object({
    cost_centre  = string
    product_name = string
    queues       = list(string)
  }))
  default = {}
}

variable "staging" {
  description = "The Azure Service Bus configuration for the 'staging' environment"
  type = map(object({
    cost_centre  = string
    product_name = string
    queues       = list(string)
  }))
  default = {}
}

variable "production" {
  description = "The Azure Service Bus configuration for the 'production' environment"
  type = map(object({
    cost_centre  = string
    product_name = string
    queues       = list(string)
  }))
  default = {}
}