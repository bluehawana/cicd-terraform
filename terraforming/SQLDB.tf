resource "azurerm_mssql_database" "AppDB" {
  name           = "hzsqldb"
  server_id      = azurerm_mssql_server.SQLServer.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  #read_scale     = true
  sku_name       = "Basic"
  #zone_redundant = true
depends_on = [
  azurerm_mssql_server.SQLServer
]
}