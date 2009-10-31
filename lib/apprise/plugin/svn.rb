require 'apprise/plugin/base'

module Apprise
  class Plugin
    class SVN < Base
      def self.repo?(directory)
        (directory + '.svn').exist?
      end
      
      executable :svn
      
      def url
        @url ||= svn('info').match(/^URL: (.+)$/)[1]
      end
      
      def latest_revision
        revision url
      end
      
      def current_revision
        revision
      end
      
      def update!
        svn "up"
      end
      
      private
      
      def revision(url = nil)
        svn("log -l 1 #{url}").match(/^r(\d+)\s\|/)[1].to_i
      end
    end
  end
end