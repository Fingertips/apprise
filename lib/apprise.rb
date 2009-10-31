require 'apprise/plugin'
require 'apprise/bundler'

module Apprise
  class << self
    attr_accessor :rails_root
  end
  
  if const_defined?(:Rails)
    self.rails_root = Apprise.rails_root
  else
    self.rails_root = Pathname.new(Dir.pwd)
  end
  
  def self.dependencies
    dependencies = []
    dependencies.concat Apprise::Bundler.dependencies if Apprise::Bundler.usable?
    dependencies.concat Apprise::Plugin.dependencies
    dependencies
  end
  
  def self.outdated
    outdated = []
    outdated.concat Apprise::Bundler.outdated if Apprise::Bundler.usable?
    outdated.concat Apprise::Plugin.outdated
    outdated
  end
  
  def self.run
    outdated = self.outdated
    if outdated.empty?
      puts "There are no outdated dependencies."
    else
      puts "Outdated dependencies"
      outdated.each do |name, source_type|
        puts " * #{name} (#{_humanize_source_type(source_type)})"
      end
    end
  end
  
  def self._humanize_source_type(source_type)
    case source_type
    when 'svn'
      'Subversion external'
    when 'git'
      'Git submodule'
    else
      'Gem'
    end
  end
end