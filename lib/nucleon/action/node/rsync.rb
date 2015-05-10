module Nucleon
module Action
module Node
class Rsync < Nucleon.plugin_class(:nucleon, :cloud_action)

  #-----------------------------------------------------------------------------
  # Info

  def self.describe

    description = "
RSync Nucleon and CORL to the Vagrant development server.
"

    describe_base(:node, :rsync, 0,
      "RSync Nucleon and CORL to the Vagrant development server",
      description
    )
  end

  #-----------------------------------------------------------------------------
  # Settings

  def configure
    super do
      register_nodes :rsync_nodes, []

      register_str :ruby_version, 'ruby-2.1.5'
      register_bool :show_commands, false
    end
  end

  #---

  def ignore
    node_ignore - [ :node_provider, :parallel ]
  end

  def arguments
    [ :rsync_nodes ]
  end

  #-----------------------------------------------------------------------------
  # Settings

  def execute
    super do |local_node|
      ensure_node(local_node) do
        batch_success = network.batch(settings[:rsync_nodes], settings[:node_provider], settings[:parallel]) do |node|
          hostname  = node.hostname
          public_ip = node.public_ip
          ssh_port  = node.ssh_port
          ssh_user  = node.user

          # Base command
          rsync_base_command = "rsync -avz --no-o --no-g --no-p --exclude '.git' --omit-dir-times"
          rsync_base_command << " -e 'ssh -i #{network.directory}/build/keys/#{hostname}_rsa -p #{ssh_port}'"

          # Nucleon command
          nucleon_version = Util::Disk.read("#{network.directory}/gems/nucleon/VERSION")

          info("RSyncing Nucleon #{nucleon_version} to #{hostname}", { :i18n => false })
          rsync_nucleon_command = rsync_base_command + " #{network.directory}/gems/nucleon/"
          rsync_nucleon_command << " #{ssh_user}@#{public_ip}:/usr/local/rvm/gems/#{settings[:ruby_version]}/gems/nucleon-#{nucleon_version}/"

          if settings[:show_commands]
            success(rsync_nucleon_command, { :i18n => false })
          else
            logger.info(rsync_nucleon_command)
          end
          nucleon_result = local_node.command(rsync_nucleon_command) unless settings[:show_commands]

          # CORL command
          corl_version = Util::Disk.read("#{network.directory}/gems/corl/VERSION")

          info("RSyncing CORL #{corl_version} to #{hostname}", { :i18n => false })
          rsync_corl_command = rsync_base_command + " #{network.directory}/gems/corl/"
          rsync_corl_command << " #{ssh_user}@#{public_ip}:/usr/local/rvm/gems/#{settings[:ruby_version]}/gems/corl-#{corl_version}/"

          if settings[:show_commands]
            success(rsync_corl_command, { :i18n => false })
          else
            logger.info(rsync_corl_command)
          end
          corl_result = local_node.command(rsync_corl_command) unless settings[:show_commands]

          if ! settings[:show_commands]
            nucleon_result.status == code.success && corl_result.status == code.success
          else
            true
          end
        end
        myself.status = code.batch_error unless batch_success
      end
    end
  end
end
end
end
end
