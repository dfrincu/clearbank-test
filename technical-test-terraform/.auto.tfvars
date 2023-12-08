test = {
  name = "test"
  service_buses = {
    namespace-1 = {
      cost_centre  = "cc-1"
      product_name = "pn-1"
      queues       = ["some-queue", "another-queue"]
    }
    namespace-2 = {
      cost_centre  = "cc-2"
      product_name = "pn-2"
      queues       = ["a-queue", "another-queue"]
    }
  }
}

staging = {
  name = "staging"
  service_buses = {
    namespace-1 = {
      cost_centre  = "cc-1"
      product_name = "pn-1"
      queues       = ["some-queue", "another-queue"]
    }
    namespace-2 = {
      cost_centre  = "cc-2"
      product_name = "pn-2"
      queues       = ["a-queue", "another-queue"]
    }
  }
}

production = {
  name = "production"
  service_buses = {
    namespace-1 = {
      cost_centre  = "cc-1"
      product_name = "pn-1"
      queues       = ["some-queue", "another-queue"]
    }
    namespace-2 = {
      cost_centre  = "cc-2"
      product_name = "pn-2"
      queues       = ["a-queue", "another-queue"]
    }
  }
}
