module Scorm2004
  module Sequencing
    class Process
      def initialize(activity_tree, options = {})
        @activity_tree, @options = activity_tree, options 
        raise "invalid options for Process: #{options}" unless options.respond_to?(:[])
      end

      def self.inherited(subclass)
        define_method(subclass.to_s.split('::').last.underscore.intern) do |options|
          subclass.run(@activity_tree, options)
        end
      end

      def self.option(option)
        define_method(option) { @options[option] }
      end

      def self.run(*args)
        self.new(*args).run
      end

      private

      def exception(code)
        raise Exception.new(code)        
      end
    end
  end
end
