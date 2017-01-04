class TweetsController < ApplicationController

  before_action :move_to_signin, only: [:new, :create, :destroy, :edit, :update]

  def index
    @tweets = Tweet.includes(:user).page(params[:page]).per(8).order("created_at DESC")
  end

  def show
    @tweet = Tweet.find(params[:id])
    @comments = @tweet.comments.includes(:user)
    if @tweet[:heartrate_flag] then
      heartrates = Heartrate.find_by(tweet_id: params[:id])
      require "pp"
      pp heartrates
      @heartrates = heartrates[:heart_rates].collect{|i| [Time.zone.parse(i["time"]), i["value"]]}
      pp @heartrates
      # 最大心拍数及び最小心拍数を指定する
      margin_tick = 10
      @max_tick = @tweet[:max_heartrate] + margin_tick
      @min_tick = @tweet[:min_heartrate] - margin_tick
    end
    if not(@tweet.user.hr_mean.nil?) then
      # 平均心拍数可視化のための準備
      middle_index = @heartrates.length / 2
      @heartrates_mean = heartrates[:heart_rates].collect{|i| [Time.zone.parse(i["time"]), @tweet.user.hr_mean]}
      if @tweet[:max_heartrate] < @tweet.user.hr_mean then
        @max_tick = @tweet.user.hr_mean + margin_tick
      end
      if @tweet[:min_heartrate] > @tweet.user.hr_mean then
        @min_tick = @tweet.user.hr_mean - margin_tick
      end
    end
  end

  def search
    query = "#{params[:keyword]}"
    # 検索する心拍数を取得する
    match_object = query.match(/[0-9]+bpm/)
    if not match_object.nil?
      bpm = match_object[0]
      bpm.slice!(/bpm/)
    else
      bpm = nil
    end
    # 検索する文字列を取得する
    query.slice!(/[0-9]+bpm/)
    # 検索結果を@tweetsに格納する
    if bpm.nil? && query==""
      @tweets = []
    elsif bpm.nil?
      @tweets = Tweet.where("text like (?)", "%#{query}%").page(params[:page]).per(5).order("created_at DESC")
    else
      @tweets = Tweet.where("text like (?) AND min_heartrate < ? AND max_heartrate > ?", "%#{query}%", bpm, bpm).page(params[:page]).per(5).order("created_at DESC")
    end
  end


  def new
    @tweet = Tweet.new
  end

  # ツイート新規作成
  def create
    if @is_token_valid_user then
      token = Usertoken.find_by(user_id: current_user[:id])
      # tokenが有効かどうか判定する→ダメだったら更新する
      require "pp"
      pp Time.now()
      pp token[:expires_at]
      if Time.now() > token[:expires_at]
        Usertoken.refresh_token(token)
      end
      heartrate = Heartrate.new
      heartrate.get_heartrates(token[:access_token], params[:acqusition_beforetime_min].to_i)
      min_heartrate, max_heartrate = heartrate.get_minmax_heartrate()
      heartrate_flag = true
      if min_heartrate.nil?
        heartrate_flag = false
      end
    else
      min_heartrate = nil
      max_heartrate = nil
      heartrate_flag = false
    end

    tweet_saved = {min_heartrate: min_heartrate, max_heartrate: max_heartrate, text: tweet_params[:text], user_id: current_user.id, heartrate_flag: heartrate_flag}
    if not(tweet_params[:image].nil?)
      tweet_saved["image"] = tweet_params[:image]
    end
    if not(tweet_params[:movie].nil?)
      tweet_saved["movie"] = tweet_params[:movie]
    end
    tweet = Tweet.create(tweet_saved)
    tweet_id = tweet[:id]
    # 心拍数テーブルへの保存| 平均心拍数の取得
    if @is_token_valid_user && not(min_heartrate.nil?) then
      heartrate.save_hr(tweet_id)
      User.update_heartrate_params(current_user[:id], heartrate.get_mean_heartrate())
    end
  end

  # ツイート削除
  def destroy
    tweet = Tweet.find(params[:id])
    tweet.destroy if tweet.user_id == current_user.id
  end

  def edit
    @tweet = Tweet.find(params[:id])
  end

  def update
    # binding.pry
    tweet = Tweet.find(params[:id])
    tweet.update(tweet_params)
  end

  private
  # ストロングパラメータの生成
  def tweet_params
    # form_tagから送られてきた情報の利用
    params.require(:tweet).permit(:text, :acqusition_beforetime_min, :image, :movie)
  end

  def move_to_signin
    redirect_to "/users/sign_in" unless user_signed_in?
  end

end
