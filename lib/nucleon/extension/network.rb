
module Nucleon
module Extension
class Network < CORL.plugin_class(:nucleon, :extension)

  def network_config(config)
    config[:directory] = File.join(File.dirname(__FILE__), '..', '..', '..')
    config
  end      
end
end
end
