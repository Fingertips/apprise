require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  t.test_files = FileList['spec/**/*_spec.rb']
  t.verbose = true
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name     = "apprise"
    s.homepage = "http://github.com/Fingertips/apprise"
    s.email    = ["manfred@fngtps.com", "eloy@fngtps.com"]
    s.authors  = ["Manfred Stienstra", "Eloy Duran"]
    s.summary  = s.description = "Apprise gives an overview of the dependencies of a Rails application."
    s.files    -= FileList['.gitignore', 'Rakefile', '.kick', 'spec/**/*', 'spec/fixtures/rails_root/vendor/plugins/.other_hidden_dir/ignore_me!']
    s.test_files = []
  end
rescue LoadError
end
 
begin
  require 'jewelry_portfolio/tasks'
  JewelryPortfolio::Tasks.new do |p|
    p.account = 'Fingertips'
  end
rescue LoadError
end