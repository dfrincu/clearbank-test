variables {
  test = {
    name = "test"
    service_buses = {
      namespace-1 = {
        cost_centre  = "cc-1"
        product_name = "pn-1"
        queues       = ["some-queue"]
      }
    }
  }
}

run "should_provision_resources_with_correct_names" {
  command = plan

  assert {
    condition     = azurerm_resource_group.rg["namespace-1-test"].name == "rg-namespace-1-test"
    error_message = "Resource Group name did not match expected"
  }

  assert {
    condition     = azurerm_management_lock.rg_lock["namespace-1-test"].name == "ml-namespace-1-test"
    error_message = "Management Lock name did not match expected"
  }

  assert {
    condition     = azurerm_servicebus_namespace.sbn["namespace-1-test"].name == "sbns-namespace-1-test"
    error_message = "Service Bus Namespace did not match expected"
  }

  assert {
    condition     = azurerm_servicebus_namespace.sbn["namespace-1-test"].tags.cost_centre == "cc-1"
    error_message = "Service Bus Cost Centre Tag did not match expected"
  }

  assert {
    condition     = azurerm_servicebus_namespace.sbn["namespace-1-test"].tags.product_name == "pn-1"
    error_message = "Service Bus Product Name Tag did not match expected"
  }

  assert {
    condition     = azurerm_servicebus_queue.queue["some-queue-namespace-1-test"].name == "sbq-some-queue-test"
    error_message = "Queue name did not match expected"
  }
}
