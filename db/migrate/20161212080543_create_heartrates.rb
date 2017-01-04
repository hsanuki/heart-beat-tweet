class CreateHeartrates < ActiveRecord::Migration
  def change
    create_table :heartrates do |t|

      t.timestamps null: false
      t.integer :tweet_id
      t.text :heart_rates
    end
  end
end
