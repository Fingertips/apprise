module Apprise
  class Bundler
    begin
      require 'rubygems' rescue nil
      require 'bundler'
      
      def self.gemfile_path
        Apprise.rails_root + 'Gemfile'
      end

      def self.outdated
        environment = ::Bundler::Environment.load(gemfile_path)
        environment.send(:repository).outdated_gems.map do |name|
          [name, 'gem']
        end
      end

      def self.usable?; true; end
    rescue LoadError
      def self.usable?; false; end
    end
  end
end