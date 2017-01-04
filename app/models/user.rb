class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :email, presence: true # 入力必須項目
  validates :account_name, presence: true # 入力必須項目
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :tweets
  has_many :comments               #commentsテーブルとのアソシエーション

  # プロフィール画像の設定
  # サイズを強制的にリサイズする
  # http://qiita.com/zakihaya/items/8b6f5510871b49870559
  has_attached_file :avatar, styles: { medium: "100x100!", large:"100x100!", thumb: "100x100!"}, :default_url => "/images/default_avator.png"
  validates_attachment_content_type :avatar, content_type: ["image/jpg","image/jpeg","image/png"]

  def self.update_heartrate_params(user_id, mean_heartrate)
    user = User.find(user_id)
    user_update_params = {}
    user[:hr_cnt] = 0 if user[:hr_cnt].nil?
    user[:hr_mean] = 0 if user[:hr_mean].nil?
    hr_mean = (user[:hr_cnt] * user[:hr_mean] + mean_heartrate) / (user[:hr_cnt] + 1)
    user_update_params[:hr_cnt] = user[:hr_cnt] + 1
    user_update_params[:hr_mean] = hr_mean
    user.update(user_update_params)
  end
end