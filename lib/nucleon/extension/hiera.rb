
module Nucleon
module Extension
class Hiera < CORL.plugin_class(:nucleon, :extension)

  def hiera_config(config)
    config[:hierarchy] = [
      "identities/%{::corl_identity}/nodes/%{::corl_provider}/%{::fqdn}",
      "identities/%{::corl_identity}/stages/%{::corl_stage}",
      "identities/%{::corl_identity}/environments/%{::corl_environment}",
      "identities/%{::corl_identity}/types/%{::corl_type}",
      "identities/%{::corl_identity}/identity",
      "nodes/%{::corl_provider}/%{::fqdn}/%{::corl_stage}",
      "nodes/%{::corl_provider}/%{::fqdn}",
      "environments/%{::corl_environment}/%{::corl_stage}",
      "environments/%{::corl_environment}",
      "stages/%{::corl_stage}",
      "types/%{::corl_type}"
    ]
    config
  end      
end
end
end
