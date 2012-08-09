module Fission
  class Config
    attr_accessor :attributes

    CONF_FILE = File.expand_path '~/.fissionrc'

    def initialize
      @attributes = {}
      @vars = ['vm_dir', 'vmrun_bin', 'plist_file', 'gui_bin', 'guest_iso'].freeze
      @fusion3_defaults = {}
      @fusion4_defaults = {}
      # This load the user-provided config. If not available, load defaults.
      load_from_file

      @vars.each do |var|
        if @attributes[var].nil?
          @attributes[var] = find(var)
        end
      end
      if !@attributes['vmrun_bin'].nil?
        @attributes['vmrun_cmd'] = "#{@attributes['vmrun_bin'].gsub(' ', '\ ')} -T fusion"
      end
    end

    private
    def load_from_file
      if File.file?(CONF_FILE)
        @attributes.merge!(YAML.load_file(CONF_FILE))
      end
      if @attributes.length != @vars.length
        puts '~/.fissionrc does not exist (or not all variables defined). Using default configuration.'
        @fusion3_defaults = Defaults.new('Fusion 3')
        @fusion4_defaults = Defaults.new('Fusion 4')
      end
    end

    private
    def find(var)
      print "Looking for #{var}...  "
      tmp = eval("@fusion4_defaults." + var)
      if File.exist?(tmp)
        puts "#{var} found at #{tmp}."
        return tmp
      else
        tmp = eval("@fusion3_defaults." + var)
        if File.exist?(tmp)
          puts "#{var} found at #{tmp}."
          return tmp
        else puts "#{var} not found. This is going to fail."
        end
      end
    end

  end #Class

  class Defaults
    attr_accessor :vm_dir
    attr_accessor :vmrun_bin
    attr_accessor :guest_iso
    attr_accessor :gui_bin
    attr_accessor :plist_file

    def initialize(version)
      if version=='Fusion 3'
        @vm_dir = File.expand_path('~/Documents/Virtual Machines.localized/')
        @vmrun_bin = '/Library/Application Support/VMware Fusion/vmrun'
        @guest_iso = '/Library/Application Support/VMware Fusion/isoimages/'
        @gui_bin = '/Applications/VMware Fusion.app/Contents/MacOS/vmware'
        @plist_file = File.expand_path('~/Library/Preferences/com.vmware.fusion.plist')
      end
      if version=='Fusion 4'
        @vm_dir = File.expand_path('~/Documents/Virtual Machines.localized/')
        @vmrun_bin = '/Applications/VMware Fusion.app/Contents/Library/vmrun'
        @guest_iso = '/Applications/VMware Fusion.app/Contents/Library/isoimages/'
        @gui_bin = '/Applications/VMware Fusion.app/Contents/MacOS/VMware Fusion'
        @plist_file = File.expand_path('~/Library/Preferences/com.vmware.fusion.plist')
      end
    end

  end #Class
end #Module
