
module ActiveRecord
  class Base
    def self.bq_connection(config)
      ConnectionAdapters::BQAdapter.new(logger, config)
    end
  end

  module ConnectionAdapters

    class BQColumn < Column
      private
        def simplified_type(field_type)
          field_type.downcase.to_sym
        end
    end

    class BQAdapter < AbstractAdapter
      attr_reader :project_id

      # Steal from SQLite for now :)
      class BindSubstitution < Arel::Visitors::SQLite # :nodoc:
        include Arel::Visitors::BindVisitor
      end

      def initialize(logger, config)
        super(nil, logger)

        @token           = nil
        @project_id      = config[:project_id]
        @client_id       = config[:client_id]
        @client_secret   = config[:client_secret]
        @refresh         = config[:refresh_token]
        @visitor         = BindSubstitution.new(self)
        @api_client_obj  = OAuth2::Client.new(@client_id, @client_secret, {:site => 'https://www.googleapis.com'})
        establish_api_connection
      end

      def adapter_name
        "BQ"
      end

      # This is really only suitable for queries
      def execute(sql, kind = "bigquery#queryRequest")
        log(sql, kind) do
          do_api do
            payload = { "kind" => kind, "query"  => "#{sql};" }
            response = api_connection.post("#{base_url}/queries", :body => JSON(payload), :headers => { "Content-Type" => "application/json" })
            JSON(response.body)
          end
        end
      end

      def select(sql, name, binds)
        exec_query(sql, name, binds).to_a
      end

      def exec_query(sql, name = 'SQL', binds = [])
        result = execute(sql)
        ActiveRecord::Result.new(
          result['schema']['fields'].map { |f| f['name'] },
          result['rows'].map do |row|
            row['f'].map { |col| col['v'] }
          end
        )
      end

      def exec_insert(sql, name, binds)
        raise ActiveRecordError, "Cannot use create for BQ - call ActiveRecord::Base.bq_append instead"
      end

      def exec_update(sql, name, binds)
        raise ActiveRecordError, "Update is not implemented for Google BigQuery"
      end

      def explain(sql, bind)
        " -> {Explain not implemented}"
      end

      def lease
        #TODO: NOt sure why this is needed
      end

      def columns(table, name = nil)
        do_api do
          puts "Calling columns for #{table}"
          dataset, tablename = table.split(".")
          response = api_connection.get("#{base_url}/datasets/#{dataset}/tables/#{tablename}")
          JSON(response.body)['schema']['fields'].map do |field|
            BQColumn.new(field["name"], nil, field["type"])
          end
        end
      end

      def table_exists?(table)
        do_api do
          puts "Calling table exists with #{table}"
          dataset, tablename = table.split(".")
          response = api_connection.get("#{base_url}/datasets/#{dataset}/tables/#{tablename}")
          response.status == 200
        end
      end

      def primary_key(table)
        # TODO: Doesn't really apply for BQ
        "id"
      end

      def schema_hash(table)
        {
          :schema => {
            :fields => columns(table).map do |column|
              { :name => column.name, :type => column.sql_type }
            end
          }
        }
      end

      private
        def do_api
          attempt = 1
          begin
            yield if block_given?
          rescue OAuth2::Error => e
            if e.code["code"] == 401 && attempt < 2
              puts "Auth failed: Attempting to reset token"
              refresh_access_token
              establish_api_connection
              attempt += 1
              retry
            else
              raise ActiveRecordError, e.code["message"]
            end
          end
        end

        def api_connection
          @api_connection || establish_api_connection
        end

        def establish_api_connection
          refresh_access_token if @token.blank?
          @api_connection = OAuth2::AccessToken.new(@api_client_obj, @token)
        end

        def refresh_access_token
          refresh_client_obj = OAuth2::Client.new(@client_id, @client_secret, {:site => 'https://accounts.google.com', :authorize_url => '/o/oauth2/auth', :token_url => '/o/oauth2/token'})
          refresh_access_token_obj = OAuth2::AccessToken.new(refresh_client_obj, @token, {refresh_token: @refresh})
          @token = refresh_access_token_obj.refresh!.token
        end

        def base_url
          "/bigquery/v2/projects/#{@project_id}"
        end
    end
  end
end
