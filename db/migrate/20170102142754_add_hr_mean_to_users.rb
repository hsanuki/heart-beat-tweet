class AddHrMeanToUsers < ActiveRecord::Migration
  def change
    add_column :users, :hr_mean, :integer
  end
end
