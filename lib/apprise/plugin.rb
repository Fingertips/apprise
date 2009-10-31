require 'pathname'

module Apprise
  class Plugin
    def self.plugin_root
      Apprise.rails_root + 'vendor/plugins'
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
    
    def self.outdated
      all.reject { |p| p.up_to_date? }.map { |p| [p.name, p.class.scm] }
    end
  end
end

require 'apprise/plugin/git'
require 'apprise/plugin/svn'