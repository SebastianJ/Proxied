# frozen_string_literal: true

class ProxiedCreate<%= table_name.camelize %> < ActiveRecord::Migration<%= migration_version %>
  def change
    create_table :<%= table_name %><%= primary_key_type %> do |t|
      t.string   :host,                 null: false, index: true
      t.string   :ip_address,           null: false, index: true
      t.integer  :port,                 null: false, index: true
      
      t.string   :username
      t.string   :password
      t.string   :auth_mode,            null: false, default: 'credentials', index: true
      
      t.string   :protocol,             null: false, default: 'http', index: true
      t.string   :proxy_type,           null: false, default: 'public', index: true
      t.string   :category
      
      t.string   :country,              index: true
      t.string   :city,                 index: true
      
      t.boolean  :checkable,            null: false, default: true, index: true
      t.boolean  :asyncable,            null: false, default: true, index: true
      t.datetime :last_checked_at,      index: true
      
      t.boolean  :valid_proxy,          null:  false, default: false, index: true
      t.integer  :successful_attempts,  null:  false, default: 0, index: true
      t.integer  :failed_attempts,      null:  false, default: 0, index: true
    end
    
    add_index :<%= table_name %>, [:host, :port], unique: true, name: 'index_unique_<%= table_name.singularize %>'
  end
end
