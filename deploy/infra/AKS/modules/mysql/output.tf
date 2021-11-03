output "fqdn" {
  value = azurerm_mysql_server.mysql.fqdn
}

output "login" {
  value = "${azurerm_mysql_server.mysql.administrator_login}@${azurerm_mysql_server.mysql.name}"
}

output "password" {
  value = azurerm_mysql_server.mysql.administrator_login_password
}
