class AddHrCntToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hr_cnt, :integer
  end
end
