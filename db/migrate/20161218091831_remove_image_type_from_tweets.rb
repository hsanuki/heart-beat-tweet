class RemoveImageTypeFromTweets < ActiveRecord::Migration
  def change
    remove_column :tweets, :image_type, :text
  end
end
