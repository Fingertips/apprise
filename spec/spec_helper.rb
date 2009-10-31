module Apprise
  module Initializer
    VENDOR_RAILS = File.expand_path('../../../../rails', __FILE__)
    OTHER_RAILS = File.expand_path('../../../rails', __FILE__)
    PLUGIN_ROOT = File.expand_path('../../', __FILE__)
    
    def self.rails_directory
      if File.exist?(File.join(VENDOR_RAILS, 'railties'))
        VENDOR_RAILS
      elsif File.exist?(File.join(OTHER_RAILS, 'railties'))
        OTHER_RAILS
      end
    end
    
    def self.load_dependencies
      if rails_directory
        $:.unshift(File.join(rails_directory, 'activesupport', 'lib'))
        $:.unshift(File.join(rails_directory, 'activerecord', 'lib'))
        $:.unshift(File.join(rails_directory, 'actionpack', 'lib'))
      else
        require 'rubygems' rescue LoadError
      end
      
      require 'active_support'
      # require 'active_record'
      # require 'action_controller'
      
      require 'rubygems' rescue LoadError
      
      require 'test/spec'
      require 'mocha'
      
      $:.unshift(File.join(PLUGIN_ROOT, 'lib'))
      require File.join(PLUGIN_ROOT, 'rails', 'init')
    end
    
    def self.start
      load_dependencies
    end
  end
end

FIXTURE_ROOT = File.expand_path('../fixtures', __FILE__)

require 'pathname'
module Rails
  def self.root
    @root ||= Pathname.new(File.join(FIXTURE_ROOT, 'rails_root'))
  end
end

Apprise::Initializer.start