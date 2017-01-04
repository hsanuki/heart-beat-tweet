class AddHeartrateFlagToTweets < ActiveRecord::Migration
  def change
    add_column :tweets, :heartrate_flag, :boolean
  end
end
