
include_recipe "mongodb"
include_recipe "mongodb::mongo_gem"

::Chef::Recipe.send(:include, MongoDB::OpsWorksHelper)

# if we are configuring a shard as a replicaset we do nothing in this recipe
if !node.recipe?("mongodb::shard")

  # assuming for the moment only one layer for the replicaset instances
  replicaset_layer_slug_name = node['opsworks']['instance']['layers'].first
  replicaset_layer_instances = node['opsworks']['layers'][replicaset_layer_slug_name]['instances']

  Chef::ResourceDefinitionList::MongoDB.configure_replicaset(node, replicaset_layer_slug_name, replicaset_members(node, replicaset_layer_instances))
end
