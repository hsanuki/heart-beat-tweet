class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.text  :text
      t.text  :image
      t.text  :image_type
      t.integer  :user_id
      t.integer    :min_heartrate
      t.integer    :max_heartrate
      t.timestamps null: false
    end
  end
end
