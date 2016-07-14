module InsensitiveLoad
  module Collector
    class Base
      attr_reader \
          :collection,
          :delimiter

      # - - - - - - - - - - - - - - - - - -
      # error

      PathError = Class.new(::ArgumentError) do
        def initialize(path)
          message = 'The path "%s" is not available.' % path
          super(message)
        end
      end

      # - - - - - - - - - - - - - - - - - -
      # initialize

      def initialize(path_src, **options)
        if not validate_path(path_src)
          fail PathError.new(path_src)
        end

        set_options(**options)
        @collection = collect(path_src)
      end

      # - - - - - - - - - - - - - - - - - -
      # setter

      def set_options(
          delimiter: Collector::DEFAULT_DELIMITER)
        @delimiter = delimiter
      end

      private

      # - - - - - - - - - - - - - - - - - -
      # validate

      def validate_path(path_src)
        if not path_src.kind_of?(String) \
            || path_src.size < 1
          return false
        end

        true
      end

    end
  end
end