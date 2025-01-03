class CreateComments < ActiveRecord::Migration[7.0]
    def change
      create_table :comments do |t|
        t.text :content, null: false
        t.string :author_name
        t.references :post, null: false, foreign_key: true
        t.references :user, foreign_key: true

        t.timestamps
      end
    end
end
