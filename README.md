# test8-pru12-fw

### Pre-requisites:
- new service principal with permissions to read/write tfstate storage account and perform CRUD operations on firewall policy
- configure service principal for federated credentials with this GH repo
- use GH app to update GH environment secrets and variables for service principal information


### information required from ALZ deployment
- management subscription id to read tfstate
- connectivity subscription id where VWAN is created
- resource group, storage account name, container name, filename for tfstate
- resource group of VWAN hub firewall, VWAN hub firewall policy id
