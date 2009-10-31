module Apprise
  class Plugin
    def self.plugin_root
      Rails.root + 'vendor/plugins'
    end
    
    def self.plugin?(pathname)
      pathname.directory? and pathname.basename.to_s != '.svn'
    end
    
    def self.all
      plugin_root.children.map do |child|
        new(child) if plugin?(child)
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