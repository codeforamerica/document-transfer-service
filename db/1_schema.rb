Sequel.migration do
  change do
    create_table(:consumers) do
      String :id, :null=>false
      String :name, :text=>true, :null=>false
      TrueClass :active, :default=>true
      DateTime :created, :null=>false
      DateTime :updated, :null=>false

      primary_key [:id]
    end

    create_table(:jobs, :ignore_index_errors=>true) do
      primary_key :id
      Integer :priority, :default=>0
      Integer :attempts, :default=>0
      String :handler, :text=>true
      DateTime :run_at
      DateTime :locked_at
      String :locked_by, :text=>true
      DateTime :failed_at
      String :last_error, :text=>true
      String :queue, :size=>128
      String :cron, :text=>true

      index [:locked_at], :name=>:index_delayed_jobs_locked_at
      index [:priority, :run_at], :name=>:index_delayed_jobs_run_at_priority
    end

    create_table(:schema_migrations) do
      String :filename, :text=>true, :null=>false

      primary_key [:filename]
    end

    create_table(:auth_keys) do
      String :id, :null=>false
      foreign_key :consumer_id, :consumers, :type=>String, :null=>false, :key=>[:id]
      TrueClass :active, :default=>true
      String :key, :text=>true, :null=>false
      DateTime :created, :null=>false
      DateTime :updated, :null=>false
      DateTime :expires, :null=>false
      DateTime :last_access

      primary_key [:id]
    end
  end
end
