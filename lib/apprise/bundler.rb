module Apprise
  class Bundler
    begin
      require 'bundler'
      
      def self.gemfile_path
        Rails.root + 'Gemfile'
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