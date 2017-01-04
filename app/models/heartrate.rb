class Heartrate < ActiveRecord::Base
  serialize :heart_rates

  def get_heartrates(access_token, acqusition_beforetime_min)
    starttime, endtime = calc_starttime_endtime(acqusition_beforetime_min)
    # binding.pry
    require "pp"
    pp starttime
    pp endtime
    today = Time.current.strftime("%Y-%m-%d")
    res = RestClient.get "https://api.fitbit.com/1/user/-/activities/heart/date/#{today}/1d/1min/time/#{starttime}/#{endtime}.json", {'Authorization' => "Bearer #{access_token}"}
    res_parsed = JSON.parse(res)
    pp res_parsed
    @heartrates = res_parsed["activities-heart-intraday"]["dataset"]
  end

  def get_minmax_heartrate()
    min_heartrate = @heartrates.collect{|i| i["value"]}.min
    max_heartrate = @heartrates.collect{|i| i["value"]}.max
    return min_heartrate, max_heartrate
  end

  def get_mean_heartrate()
    heartrates = @heartrates.collect{|i| i["value"]}
    mean_heartrate = heartrates.inject{ |sum, el| sum + el }.to_f / heartrates.size
    return mean_heartrate
  end

  def save_hr(tweet_id)
    Heartrate.create(tweet_id: tweet_id, heart_rates: @heartrates)
  end

  private
  def calc_starttime_endtime(acqusition_beforetime_min)
    time_interval = 30 # 何分間の心拍数を取得するか
    day = Time.current
    startdatetime = day - (acqusition_beforetime_min + (time_interval / 2)) * 60
    enddatetime = day - (acqusition_beforetime_min - (time_interval / 2)) * 60
    if startdatetime.day != enddatetime.day
      # 日付をまたぐ場合の例外処理
    end
    starttime = "#{startdatetime.hour}:#{startdatetime.min}"
    endtime = "#{enddatetime.hour}:#{enddatetime.min}"
    return starttime, endtime
  end

end