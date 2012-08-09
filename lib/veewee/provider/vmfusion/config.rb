# This is essentially a copy of /veewee/lib/fission/config.rb
# Things that we don't need for Vmfusion module are stripped off.
module Veewee
  module Provider
    module Vmfusion
      class Config
        attr_accessor :attributes


        CONF_FILE = File.expand_path '~/.fissionrc'

        def initialize
          @attributes = {}
          load_from_file

          if @attributes['vm_dir'].nil?
            # Fusion default vm location
            tmp = File.expand_path('~/Documents/Virtual Machines.localized')
            if File.directory?(tmp)
              @attributes['vm_dir'] = tmp
            else
              puts 'directory Virtual Machines.localized not found'
            end
          end

          if @attributes['vmrun_bin'].nil?
            @attributes['vmrun_bin'] = find_vmrun
          end

          if @attributes['guest_iso'].nil?
            # determine isoimage/ based on the vmrun path
            tmp = @attributes['vmrun_bin'].chomp("vmrun")
            @attributes['guest_iso'] = tmp + "isoimages"
          end
        end

        private
        def load_from_file
          if File.file?(CONF_FILE)
            @attributes.merge!(YAML.load_file(CONF_FILE))
          
          end
        end

        private
        def find_vmrun
          vmrun_bin = nil
          # Fusion 4 path                                                                               
          if File.exist?('/Applications/VMware Fusion.app/Contents/Library/vmrun')
            vmrun_bin = '/Applications/VMware Fusion.app/Contents/Library/vmrun'
            # Fusion 3 path                                                                               
          elsif File.exist?('/Library/Application Support/VMware Fusion/vmrun')
            vmrun_bin = '/Library/Application Support/VMware Fusion/vmrun'
          end
          if vmrun_bin == nil
            puts 'vmrun not found'
            return nil
          else
            return vmrun_bin
          end
        end

      end #Class
    end #Module
  end #Module
end #Module
