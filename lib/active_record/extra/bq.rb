require 'csv'
require 'multipart_body'

module ActiveRecord
  module Extra
    module BQ
      # Can provide a CSV via the block
      # Or specify a filename or URI
      # 
      def bq_append(options = {}, &block)
        if block_given?
          headers = columns.map(&:name)
          # TODO: Validate row length (AND types?)
          csv     = CSV.generate { |csv| yield(csv) }
          data_part(csv)
        end
      end

      # TODO: split these on table name
      def table_id

      end

      def dataset_id

      end

      private
        def data_part(csv)
          Part.new(:body => csv, :content_type => "application/octet-stream")
        end
    end
  end
end
