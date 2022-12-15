resource "azurerm_log_analytics_workspace" "dbworkanalytics" {
  name                = "dbworkspace2023"
  location            = local.rglocation
  resource_group_name = local.rgname
  sku                 = "PerGB2018"
  retention_in_days   = 30
  depends_on = [
    azurerm_resource_group.HZlab1
  ]
}
