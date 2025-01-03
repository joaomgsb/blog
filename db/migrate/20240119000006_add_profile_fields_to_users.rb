class AddProfileFieldsToUsers < ActiveRecord::Migration[7.0]
    def change
      add_column :users, :name, :string
      add_column :users, :username, :string
      add_column :users, :bio, :text
      add_column :users, :avatar_url, :string
      add_column :users, :website, :string
      add_column :users, :location, :string
      add_column :users, :twitter_username, :string
      add_column :users, :github_username, :string

      add_index :users, :username, unique: true
    end
end
