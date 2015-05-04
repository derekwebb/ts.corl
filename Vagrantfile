#
# CORL Vagrant environment (development platform)
#-------------------------------------------------------------------------------
#
ENV['CORL_NO_NETWORK_SHARE'] = '1'

Vagrant.configure('2') do |config|
  CORL.vagrant_config(File.dirname(__FILE__), config) do |node, machine, provisioner|
    provisioner.dev_build = true
    provisioner.reboot    = true
    
    provisioner.seed      = false
    
    provisioner.environment = "production"
    provisioner.build       = true
    provisioner.provision   = true
    provisioner.dry_run     = false
  end
end
