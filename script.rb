require 'kubeclient'
config = Kubeclient::Config.read(ENV['KUBECONFIG'] || File.expand_path('~/.kube/config'))
context = config.context
client_v1 = Kubeclient::Client.new(
  context.api_endpoint,
  'v1',
  ssl_options: context.ssl_options,
  auth_options: context.auth_options
)
client_apps = Kubeclient::Client.new(
#   'http://c9cee005-5dbe-44ef-8854-64e3c0c99ab5.k8s.ondigitalocean.com:443/apis/apps/',
  context.api_endpoint + '/apis/apps/',
  'v1',
  ssl_options: context.ssl_options,
  auth_options: context.auth_options
)
puts "hi"


# puts yaml

def update_or_create_namespace(client, namespace)
	client.update_namespace(namespace)
rescue Kubeclient::ResourceNotFoundError
	client.create_namespace(namespace)
end


def update_or_create(type, client, namespace)
	client.update(type, namespace)
rescue Kubeclient::ResourceNotFoundError
	client.create(type, namespace)
end

def update_or_create_deployment(client, deployment)
	client.update_deployment(deployment)
rescue Kubeclient::ResourceNotFoundError
	client.create_deployment(deployment)
end

namespace_name = 'testing125o'

yaml = YAML.load(File.read('namespace.yml'))
yaml["metadata"]["name"] = namespace_name

namespace = Kubeclient::Resource.new(yaml)



yaml = YAML.load(File.read('icecast-deployment.yml'))
yaml["metadata"]["namespace"] = namespace_name
deployment = Kubeclient::Resource.new(yaml)
# p deployment 

#exit
#puts namespace.entity
# puts "creando namespace"
#client.get_namespaces

# puts client.methods(true)

p update_or_create_namespace(client_v1, namespace)

client_v1.get_namespaces
p update_or_create_deployment(client_apps, deployment)
p client_apps.get_deployments

# p namespace
# puts "imprimiendo namespaces"
