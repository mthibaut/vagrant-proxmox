module VagrantPlugins
  module Proxmox
    module Action

      # set env[:result] to :is_created
      class IsCreated < ProxmoxAction

        def initialize app, env
          @app = app
        end

        def call env
          env[:result] = env[:machine].state.id != :not_created
          next_action env
        end

      end

    end
  end
end
