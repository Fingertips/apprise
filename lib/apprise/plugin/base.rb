module Apprise
  class Plugin
    class Base
      class NotImplementedError < StandardError; end
      
      def initialize(pathname)
        @pathname = pathname
      end
      
      def name
        @pathname.basename.to_s
      end
      
      def up_to_date?
        raise NotImplementedError, "The class `#{self.class.name}' does not implement the #up_to_date? method."
      end
    end
  end
end