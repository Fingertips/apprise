# encoding: utf-8

require 'apprise/plugin/base'

module Apprise
  module Plugin
    class Git < Base
      def self.repo?(directory)
        (directory + '.git').exist?
      end
      
      executable :git
      
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
      
      def update!
        git "pull #{current_remote} #{current_branch} 2>&1"
      end
      
      private
      
      def fetch!
        git "fetch #{current_remote} #{current_branch} 2>&1"
      end
      
      def revision(refspec = nil)
        git "log -n 1 --pretty=format:%H #{refspec}"
      end
    end
  end
end