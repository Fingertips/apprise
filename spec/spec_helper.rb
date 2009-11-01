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
    
    def self.start
      load_dependencies
    end
  end
end


module Collector
  class << self
    attr_accessor :output
    
    def write(string)
      @output ||= []
      @output << string
    end
    
    def output
      @output
    end
    
    def reset!
      @output.clear if @output
    end
  end
end

require 'test/unit'
class Test::Unit::TestCase
  def setup
    Apprise.rails_root = Pathname.new(File.expand_path('../fixtures/rails_root', __FILE__))
  end
  
  def clean_environment!
    ENV.keys.dup.each do |key|
      if key =~ /^GIT_/
        ENV[key] = nil
      end
    end
  end
  
  def svn_repo
    "file://#{FIXTURE_ROOT + 'repos/svn/trunk'}"
  end
  
  def git_repo
    FIXTURE_ROOT + 'repos/git'
  end
  
  def svn_checkout
    Apprise.rails_root + 'vendor/plugins/svn'
  end
  
  def git_checkout
    Apprise.rails_root + 'vendor/plugins/git'
  end
  
  def checkout_svn_fixture_repo!
    checkout 'svn co -r1', svn_repo, svn_checkout
    Apprise::Plugin::SVN.new(svn_checkout)
  end
  
  def checkout_git_fixture_repo!
    unless File.exist?(git_repo)
      unless system("cd #{FIXTURE_ROOT + 'repos'} && tar -xzvf git.tgz > /dev/null 2>&1")
        raise "Unable to unpack git fixture repo…"
      end
    end
    
    clean_environment!
    
    checkout 'git clone', git_repo, git_checkout
    unless system "cd #{git_checkout} && git reset b200b30bcf41e674b8c1bd013316498dfa193077 --hard  > /dev/null 2>&1"
      raise "Unable to reset the git repo…"
    end
    
    Apprise::Plugin::Git.new(git_checkout)
  end
  
  def collect_stdout
    Collector.reset!
    before = $stdout
    $stdout = Collector
    yield
    $stdout = before
    Collector.output.join
  end
  
  private
  
  def checkout(cmd, repo, checkout)
    FileUtils.rm_rf checkout
    unless system("#{cmd} #{repo} #{checkout} > /dev/null 2>&1")
      raise "Creating checkout of `#{repo}' in `#{checkout}' failed…"
    end
  end
end

Apprise::Initializer.start