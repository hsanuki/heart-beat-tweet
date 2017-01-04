class Usertoken < ActiveRecord::Base
  def self.refresh_token(token)
    # リフレッシュトークンを再利用するべきだけど，できない
    # response = RestClient.post "http://localhost:3000/auth/fitbit_oauth2/token", :grant_type => 'refresh_token', :refresh_token => token[:refresh_token], :client_id => "227YDT", :client_secret => "d2c2fdd07deb12a78f2b6cbed91dbbcf"
    token.destroy
  end
end