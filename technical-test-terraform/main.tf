locals {
  service_buses = flatten([
    for environment in tolist([var.test, var.staging, var.production]) : [
      for service_bus_name, service_bus in environment.service_buses : {
        environment          = environment.name
        resource_group_name  = "rg-${service_bus_name}-${environment.name}"
        management_lock_name = "ml-${service_bus_name}-${environment.name}"
        namespace            = "sbns-${service_bus_name}-${environment.name}"
        tags = {
          cost_centre  = service_bus.cost_centre
          product_name = service_bus.product_name
        }
        queues = service_bus.queues
      }
    ]
  ])

  queues = flatten([
    for index, service_bus in local.service_buses : [
      for queue in service_bus.queues : {
        sb_index = index
        name              = "sbq-${queue}-${service_bus.environment}"
      }
    ]
  ])
}

resource "azurerm_resource_group" "rg" {
  count = length(local.service_buses)

  location = "West Europe"
  name     = local.service_buses[count.index].resource_group_name
}

resource "azurerm_management_lock" "rg_lock" {
  count = length(local.service_buses)

  lock_level = "CanNotDelete"
  name       = local.service_buses[count.index].management_lock_name
  scope      = azurerm_resource_group.rg[count.index].id
}

resource "azurerm_servicebus_namespace" "sbn" {
  count = length(local.service_buses)

  name                = local.service_buses[count.index].namespace
  location            = azurerm_resource_group.rg[count.index].location
  resource_group_name = azurerm_resource_group.rg[count.index].name
  sku                 = "Standard"
  tags                = local.service_buses[count.index].tags
}

resource "azurerm_servicebus_queue" "queue" {
  count = length(local.queues)

  name         = local.queues[count.index].name
  namespace_id = azurerm_servicebus_namespace.sbn[local.queues[count.index].sb_index].id
}
