class RemoveAccountnameFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :accountname, :string
  end
end
