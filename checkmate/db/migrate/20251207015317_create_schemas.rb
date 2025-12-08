class CreateSchemas < ActiveRecord::Migration[8.0]
  def change
    create_schema :auth unless schema_exists?(:auth)
    create_schema :extensions unless schema_exists?(:extensions)
    create_schema :graphql unless schema_exists?(:graphql)
    create_schema :graphql_public unless schema_exists?(:graphql_public)
    create_schema :pgbouncer unless schema_exists?(:pgbouncer)
    create_schema :realtime unless schema_exists?(:realtime)
    create_schema :storage unless schema_exists?(:storage)
    create_schema :vault unless schema_exists?(:vault)
  end
end
