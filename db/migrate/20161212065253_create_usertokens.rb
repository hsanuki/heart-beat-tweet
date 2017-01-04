class CreateUsertokens < ActiveRecord::Migration
  def change
    create_table :usertokens do |t|
      t.integer :user_id
      t.text :access_token
      t.text :refresh_token
      t.timestamps null: false
    end
  end
end