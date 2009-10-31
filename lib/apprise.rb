require 'apprise/plugin'

module Apprise
  def self.outdated
    []
  end
  
  def self.run
    outdated = self.outdated
    if outdated.empty?
      puts "There are no outdated dependencies."
    else
      puts "Outdated dependencies", ""
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