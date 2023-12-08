locals {
  service_buses = { for sb in flatten([
    for environment in tolist([var.test, var.staging, var.production]) : [
      for service_bus_name, service_bus in environment.service_buses : {
        name        = service_bus_name
        environment = environment.name
        tags = {
          cost_centre  = service_bus.cost_centre
          product_name = service_bus.product_name
        }
        queues = service_bus.queues
      }
    ]
  ]) : "${sb.name}-${sb.environment}" => sb }

  queues = { for q in flatten([
    for service_bus_key, service_bus in local.service_buses : [
      for queue in service_bus.queues : {
        service_bus = service_bus_key
        name        = queue
        environment = service_bus.environment
      }
    ]
  ]) : "${q.name}-${q.service_bus}" => q }
}

resource "azurerm_resource_group" "rg" {
  for_each = local.service_buses

  location = "West Europe"
  name     = "rg-${each.key}"
}

resource "azurerm_management_lock" "rg_lock" {
  for_each = local.service_buses

  name       = "ml-${each.key}"
  scope      = azurerm_resource_group.rg[each.key].id
  lock_level = "CanNotDelete"
}

resource "azurerm_servicebus_namespace" "sbn" {
  for_each = local.service_buses

  name                = "sbns-${each.key}"
  location            = azurerm_resource_group.rg[each.key].location
  resource_group_name = azurerm_resource_group.rg[each.key].name
  sku                 = "Standard"
  tags                = each.value.tags
}

resource "azurerm_servicebus_queue" "queue" {
  for_each = local.queues

  name         = "sbq-${each.value.name}-${each.value.environment}"
  namespace_id = azurerm_servicebus_namespace.sbn[each.value.service_bus].id
}
