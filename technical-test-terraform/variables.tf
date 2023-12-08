variable "test" {
  description = "The Azure Service Bus configuration for the 'test' environment"
  type = object({
    name = string
    service_buses = map(object({
      cost_centre  = string
      product_name = string
      queues       = list(string)
    }))
  })
  default = {
    name          = "default"
    service_buses = {}
  }
}

variable "staging" {
  description = "The Azure Service Bus configuration for the 'staging' environment"
  type = object({
    name = string
    service_buses = map(object({
      cost_centre  = string
      product_name = string
      queues       = list(string)
    }))
  })
  default = {
    name          = "default"
    service_buses = {}
  }
}

variable "production" {
  description = "The Azure Service Bus configuration for the 'production' environment"
  type = object({
    name = string
    service_buses = map(object({
      cost_centre  = string
      product_name = string
      queues       = list(string)
    }))
  })
  default = {
    name          = "default"
    service_buses = {}
  }
}
