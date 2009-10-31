require 'pathname'

module Apprise
  class Plugin
    def self.plugin_root
      Rails.root + 'vendor/plugins'
    end
    
    def self.scms
      @scms ||= []
    end
    
    def self.all
      Pathname.glob(plugin_root + '*').map do |child|
        if child.directory? && scm = scms.find { |s| s.repo?(child) }
          scm.new(child)
        end
      end.compact
    end
  end
end

require 'apprise/plugin/git'
require 'apprise/plugin/svn'