# encoding: utf-8

module Apprise
  module Plugin
    class Base
      class NotImplementedError < StandardError; end
      
      def self.inherited(klass)
        Apprise::Plugin.scms << klass
      end
      
      def self.scm
        name.split('::').last.downcase
      end
      
      def self.repo?(directory)
        raise NotImplementedError, "The class `#{self.class.name}' does not implement ::repo?"
      end
      
      def self.executable(name)
        define_method name do |args|
          out = ''
          Dir.chdir(@pathname) { out = `#{name} #{args}` }
          out.strip
        end
      end
      
      def initialize(pathname)
        @pathname = pathname
      end
      
      def name
        @pathname.basename.to_s
      end
      
      def current_revision
        raise NotImplementedError, "The class `#{self.class.name}' does not implement #current_revision."
      end
      
      def latest_revision
        raise NotImplementedError, "The class `#{self.class.name}' does not implement #latest_revision."
      end
      
      def up_to_date?
        current_revision == latest_revision
      end
      
      def update!
        raise NotImplementedError, "The class `#{self.class.name}' does not implement #update!."
      end
    end
  end
end