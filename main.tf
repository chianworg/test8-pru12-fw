# data from ESLZ deployment
data "terraform_remote_state" "alz_output" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-test8-pru12-state-southeastasia-001"
    storage_account_name = "stotesprusou001ynml"
    container_name       = "pru12-tfstate"
    key                  = "terraform.tfstate"
    subscription_id      = "a66aa8a7-28a9-457b-b879-1cfff0201ed3"
  }
}


# use AVM module for firewall rule collection group

module "rule_collection_group" {
  source = "Azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  #   firewall_policy_rule_collection_group_firewall_policy_id = data.terraform_remote_state.alz_output.module.virtual_wan[0].module.firewall_policy["secondary"].id
  firewall_policy_rule_collection_group_firewall_policy_id = "/subscriptions/ff3bfb36-04e0-42d0-a610-525c7620ed41/resourceGroups/rg-hub-southeastasia/providers/Microsoft.Network/firewallPolicies/fwp-hub-southeastasia"
  firewall_policy_rule_collection_group_name               = "NetworkRuleCollectionGroup"
  firewall_policy_rule_collection_group_priority           = 400
  firewall_policy_rule_collection_group_network_rule_collection = [
    {
      action   = "Allow"
      name     = "NetworkRuleCollection"
      priority = 400
      rule = [
        {
          name                  = "OutboundToInternet"
          description           = "Allow traffic outbound to the Internet"
          destination_addresses = ["0.0.0.0/0"]
          destination_ports     = ["443"]
          source_addresses      = ["10.0.0.0/24"]
          protocols             = ["TCP"]
        }
      ]
    }
  ]
  firewall_policy_rule_collection_group_application_rule_collection = [
    {
      action   = "Allow"
      name     = "ApplicationRuleCollection"
      priority = 600
      rule = [
        {
          name             = "AllowAll"
          description      = "Allow traffic to Microsoft.com"
          source_addresses = ["10.0.0.0/24"]
          protocols = [
            {
              port = 443
              type = "Https"
            }
          ]
          destination_fqdns = ["microsoft.com"]
        }
      ]
    }
  ]
}