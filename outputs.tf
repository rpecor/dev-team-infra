output "spoke_vnet_id" {
  value = module.netspoke.spoke_vnet_id
  description = "Spoke VNet ID for Network team peering activites."
}

output "spoke_rg_name" {
  value = module.netspoke.spoke_rg_name
  description = "Spoke RG ID for Network team peering activites."

}

output "spoke_vnet_name" {
  value = module.netspoke.spoke_vnet_name
  description = "Spoke VNet name for Network team peering activites."
}