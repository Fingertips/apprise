require 'pathname'

module Apprise
  class Plugin
    def self.plugin_root
      Rails.root + 'vendor/plugins'
    end
    
    def self.all
      Pathname.glob(plugin_root + '*').map do |child|
        new(child) if child.directory?
      end.compact
    end
    
    def initialize(pathname)
      @pathname = pathname
    end
    
    def name
      @pathname.basename.to_s
    end
  end
end