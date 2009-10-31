require 'apprise/plugin/base'

module Apprise
  class Plugin
    class SVN < Base
      def url
        @url ||= svn('info').match(/^URL: (.+)$/)[1]
      end
      
      def latest_revision
        revision url
      end
      
      def current_revision
        revision
      end
      
      def up_to_date?
        current_revision == latest_revision
      end
      
      private
      
      def svn(args)
        out = ''
        Dir.chdir(@pathname) do
          out = `svn #{args}`
        end
        out
      end
      
      def revision(url = nil)
        svn("log -l 1 #{url}").match(/^r(\d+)\s\|/)[1].to_i
      end
    end
  end
end