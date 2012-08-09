require 'veewee/provider/core/provider'

module Veewee
  module Provider
    module Vmfusion

      class Provider < Veewee::Provider::Core::Provider
        #include ::Veewee::Provider::Vmfusion::ProviderCommand

        def check_requirements
          # if Vmfusion.config.attributes['vmrun_bin'].nil?
          #     raise Veewee::Error,"The file /Applications/VMware Fusion.app/Contents/Library/vmrun does not exists. Probably you don't have Vmware fusion installed"
          # end
          puts "vmrun check is moved to config.rb"
        end

      end #End Class
    end # End Module
  end # End Module
end # End Module
