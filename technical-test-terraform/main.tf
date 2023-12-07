locals {
  environments = {
    test       = var.test
    staging    = var.staging
    production = var.production
  }

  service_buses = flatten([
    for environment_name, config in local.environments : [
      for service_bus_name, service_bus_config in config : {
        name         = "${service_bus_name}-${environment_name}"
        cost_centre  = service_bus_config.cost_centre
        product_name = service_bus_config.product_name
        queues       = service_bus_config.queues
      }
    ]
  ])

  queues = flatten([
    for index, service_bus in local.service_buses : [
      for queue in service_bus.queues : {
        service_bus_index = index
        name              = queue
      }
    ]
  ])
}

resource "azurerm_resource_group" "asbn_rg" {
  count = length(local.service_buses)

  location = "West Europe"
  name     = "rg-${local.service_buses[count.index].name}"
}

resource "azurerm_management_lock" "lock" {
  count = length(local.service_buses)

  lock_level = "CanNotDelete"
  name       = "ml-${local.service_buses[count.index].name}"
  scope      = azurerm_resource_group.asbn_rg[count.index].id
}

resource "azurerm_servicebus_namespace" "asbn" {
  count = length(local.service_buses)

  name                = "sb-${local.service_buses[count.index].name}"
  location            = azurerm_resource_group.asbn_rg[count.index].location
  resource_group_name = azurerm_resource_group.asbn_rg[count.index].name
  sku                 = "Standard"

  tags = {
    source       = "terraform",
    cost_centre  = local.service_buses[count.index].cost_centre
    product_name = local.service_buses[count.index].product_name
  }
}

resource "azurerm_servicebus_queue" "queue" {
  count = length(local.queues)

  name         = local.queues[count.index].name
  namespace_id = azurerm_servicebus_namespace.asbn[local.queues[count.index].service_bus_index].id
}