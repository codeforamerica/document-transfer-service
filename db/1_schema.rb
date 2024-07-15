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
