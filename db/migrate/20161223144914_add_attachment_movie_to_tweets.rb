class AddAttachmentMovieToTweets < ActiveRecord::Migration
  def self.up
    change_table :tweets do |t|
      t.attachment :movie
    end
  end

  def self.down
    remove_attachment :tweets, :movie
  end
end
