require 'apprise/plugin'
require 'apprise/bundler'

module Apprise
  class << self
    attr_accessor :rails_root
  end
  
  def self.dependencies
    aggregate :dependencies
  end
  
  def self.outdated
    aggregate :outdated
  end
  
  def self.run
    outdated = self.outdated
    if outdated.empty?
      puts "There are no outdated dependencies."
    else
      puts "Outdated dependencies"
      outdated.each do |name, source_type|
        puts " * #{name} (#{humanize_source_type(source_type)})"
      end
    end
  end
  
  private
  
  def self.discover_root
    Object.const_defined?(:Rails) ? Rails.root : Pathname.new(Dir.pwd)
  end
  
  self.rails_root = discover_root
  
  def self.aggregate(type)
    list = []
    list.concat Apprise::Bundler.send(type) if Apprise::Bundler.usable?
    list.concat Apprise::Plugin.send(type)
    list
  end
  
  def self.humanize_source_type(source_type)
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