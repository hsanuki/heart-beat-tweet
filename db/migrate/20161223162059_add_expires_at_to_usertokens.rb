class AddExpiresAtToUsertokens < ActiveRecord::Migration
  def change
    add_column :usertokens, :expires_at, :datetime
  end
end
