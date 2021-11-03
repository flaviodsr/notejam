resource "random_password" "db_password" {
  length           = 32
  special          = true
  override_special = "_%@"
}

resource "azurerm_mysql_server" "mysql" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  administrator_login          = var.administrator_login
  administrator_login_password = random_password.db_password.result

  sku_name          = var.sku_name
  version           = var.mysql_version
  storage_mb        = var.storage_mb
  auto_grow_enabled = false

  public_network_access_enabled    = true
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"

  tags = {
    environment = "notejam"
  }
}

resource "azurerm_mysql_database" "databases" {
  for_each = toset(var.databases)

  name                = each.value
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}


resource "azurerm_mysql_firewall_rule" "az-services" {
  name                = "${var.name}-az-services"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_server.mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
