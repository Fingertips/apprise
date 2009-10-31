$:.unshift(File.expand_path('../../', __FILE__))
require 'apprise'

namespace :deps do
  desc "Print all outdated dependencies"
  task :outdated do
    Apprise.run
  end
end