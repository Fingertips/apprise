module Apprise
  class Bundler
    begin
      require 'rubygems' rescue nil
      require 'bundler'
      
      def self.gemfile_path
        Apprise.rails_root + 'Gemfile'
      end
      
      def self.dependencies
        gem_dependencies.map { |gem| [gem.name, 'gem'] }
      end

      def self.outdated
        repository.outdated_gems.map do |name|
          [name, 'gem']
        end
      end
      
      def self.repository
        environment.send(:repository)
      end
      
      def self.gem_dependencies
        environment.send(:gem_dependencies)
      end
      
      def self.environment
        @environment ||= ::Bundler::Environment.load(gemfile_path)
      end

      def self.usable?; true; end
    rescue LoadError
      def self.usable?; false; end
    end
  end
end