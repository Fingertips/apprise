require 'apprise/plugin/base'

module Apprise
  class Plugin
    class Git < Base
      def current_branch
        git('branch -a').match(/^\* (.+)$/)[1]
      end
      
      def current_remote
        git 'remote'
      end
      
      def latest_revision
        fetch!
        revision "#{current_remote}/#{current_branch}"
      end
      
      def current_revision
        revision
      end
      
      def up_to_date?
        current_revision == latest_revision
      end
      
      def update!
        git "pull #{current_remote} #{current_branch}"
      end
      
      private
      
      def git(args)
        out = ''
        Dir.chdir(@pathname) do
          out = `git #{args}`
        end
        out.strip
      end
      
      def fetch!
        git "fetch #{current_remote} #{current_branch}"
      end
      
      def revision(refspec = nil)
        git "log -n 1 --pretty=format:%H #{refspec}"
      end
    end
  end
end