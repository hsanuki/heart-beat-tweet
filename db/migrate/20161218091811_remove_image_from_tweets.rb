class RemoveImageFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :image, :text
  end
end
