# encoding: utf-8

$:.unshift(File.expand_path('../../', __FILE__))
require 'apprise'

namespace :deps do
  desc "Print all  dependencies"
  task :all do
    Apprise.display_dependencies
  end
  
  desc "Print all outdated dependencies"
  task :outdated do
    Apprise.display_outdated
  end
end