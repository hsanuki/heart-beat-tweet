class Tweet < ActiveRecord::Base
  belongs_to :user
  has_many :comments               #commentsテーブルとのアソシエーション
  has_attached_file :image,
                      styles:  { medium: "300x300#", thumb: "100x100#" }
  validates_attachment_content_type :image,
                                      content_type: ["image/jpg","image/jpeg","image/png"]
  has_attached_file :movie
  validates_attachment_content_type :movie, content_type: ["video/quicktime"]
end