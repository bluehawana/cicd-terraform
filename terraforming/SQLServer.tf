resource "azurerm_mssql_server" "SQLServer" {
  name                         = "hzmssqlserver20221214"
  resource_group_name          = local.rgname
  location                     = local.rglocation
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "MySql?2022123"
  depends_on = [
    azurerm_resource_group.HZlab1
  ]
}

resource "azurerm_mssql_firewall_rule" "allowmyip" {
  name             = "allmyip"
  server_id        = azurerm_mssql_server.SQLServer.id
  start_ip_address = "216.158.101.81"
  end_ip_address   = "216.158.101.81"
  depends_on = [
    azurerm_mssql_server.SQLServer
  ]
}

resource "azurerm_mssql_server_extended_auditing_policy" "sqlauditing" {
  server_id = azurerm_mssql_server.SQLServer.id
  #   storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
  #   storage_account_access_key              = azurerm_storage_account.example.primary_access_key
  #   storage_account_access_key_is_secondary = false
  #   retention_in_days                       = 6
  log_monitoring_enabled = true
  depends_on = [
    azurerm_mssql_database.AppDB
  ]
}

# resource "azurerm_monitor_diagnostic_setting" "diagsetting" {
#   name               = "${azurerm_mssql_database.AppDB.name}-setting"
#   target_resource_id = azurerm_mssql_database.AppDB.id
#   #storage_account_id = data.azurerm_storage_account.example.id
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.dbworkanalytics.id

#   log {
#     category = "sqlsecurityauditevents"
#     enabled  = true

#     retention_policy {
#       enabled = false
#     }
#   }

#   depends_on = [
#     azurerm_log_analytics_workspace.dbworkanalytics
#   ]
# }
# Create Security Group
resource "azurerm_network_security_group" "LAB1B-NSG" {
  name                = "LAB1B-NSG"
  location            = local.rglocation
  resource_group_name = local.rgname
  depends_on = [
    azurerm_resource_group.HZlab1
  ]
}
resource "azurerm_virtual_network" "app-network" {
  name                = "hongzhi-network"
  location            = local.rglocation
  resource_group_name = local.rgname
  address_space       = ["10.0.0.0/16"]
  tags = {
    environment = "Lab1"
  }
  depends_on = [
    azurerm_resource_group.HZlab1
  ]
}
resource "azurerm_subnet" "SubnetB" {
  name                 = "SubnetB"
  resource_group_name  = local.rgname
  virtual_network_name = azurerm_virtual_network.app-network.name
  address_prefixes     = ["10.0.1.0/24"]
  depends_on = [
    azurerm_virtual_network.app-network
  ]
}
resource "azurerm_network_security_rule" "RDP1" {
  name                        = "AllowRDP"
  priority                    = 300
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.rgname
  network_security_group_name = azurerm_network_security_group.LAB1B-NSG.name
  depends_on = [
    #azurerm_resource_group.HZlab1,
    azurerm_network_security_group.LAB1B-NSG
  ]
}
resource "azurerm_network_security_rule" "http" {
  name                        = "Allowhttp"
  priority                    = 350
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.rgname
  network_security_group_name = azurerm_network_security_group.LAB1B-NSG.name
  depends_on = [
    #azurerm_resource_group.HZlab1,
    azurerm_network_security_group.LAB1B-NSG
  ]
}
# Create an association to subnet
resource "azurerm_subnet_network_security_group_association" "LAB1BAss" {
  subnet_id                 = azurerm_subnet.SubnetB.id
  network_security_group_id = azurerm_network_security_group.LAB1B-NSG.id
  depends_on = [
    azurerm_network_security_group.LAB1B-NSG,
    azurerm_subnet.SubnetB
  ]
}
output "NSG_ID" {
  value = azurerm_network_security_group.LAB1B-NSG.id
}

