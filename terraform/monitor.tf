/*
===============================================================================
Secure Azure Foundation – Monitoring and Logging
-------------------------------------------------------------------------------
Provides baseline visibility for the environment.

Components:
- Log Analytics Workspace: centralized log collection and retention
- Azure Monitor Agent (AMA): installs the agent on the Linux VM to enable
  telemetry collection (logs/metrics) into Log Analytics

Security Value:
- Enables investigation and auditability
- Supports alerting and detections (later enhancements)
===============================================================================
*/

###############################################################################
# Log Analytics Workspace
###############################################################################

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-secure-foundation"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku               = "PerGB2018"
  retention_in_days = 30

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
    component   = "monitoring"
  }
}

###############################################################################
# Azure Monitor Agent (Linux VM Extension)
###############################################################################

resource "azurerm_virtual_machine_extension" "ama" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true

  tags = {
    environment = "secure-baseline"
    managed_by  = "terraform"
    component   = "monitoring"
  }
}
