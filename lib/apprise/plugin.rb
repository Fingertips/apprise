# encoding: utf-8

require 'pathname'

module Apprise
  module Plugin
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
    
    def self.dependencies
      names_and_types all
    end
    
    def self.outdated
      names_and_types all.reject { |p| p.up_to_date? }
    end
    
    private
    
    def self.names_and_types(array)
      array.map { |p| [p.name, p.class.scm] }
    end
  end
end

require 'apprise/plugin/git'
require 'apprise/plugin/svn'