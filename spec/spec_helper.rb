require 'pathname'

FIXTURE_ROOT = Pathname.new(File.expand_path('../fixtures', __FILE__))

module Rails
  def self.root
    @root ||= FIXTURE_ROOT + 'rails_root'
  end
end

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
    
    def self.checkout_fixture_repos
      svn_checkout = Rails.root + 'vendor/plugins/svn'
      unless svn_checkout.exist?
        svn_repo = "file://#{FIXTURE_ROOT + 'repos/svn/trunk'}"
        puts "[!] Creating checkout of `#{svn_repo}' in `#{svn_checkout}'"
        unless system("svn co #{svn_repo} #{svn_checkout}")
          raise "Creating checkout failed…"
        end
      end
    end
    
    def self.start
      load_dependencies
      checkout_fixture_repos
    end
  end
end

Apprise::Initializer.start