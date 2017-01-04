# http://localhost:3000/auth/fitbit_oauth2で認証にアクセスする
Rails.application.config.middleware.use OmniAuth::Builder do
#provider :fitbit_oauth2, "227YDT", "c4d4fa78d0a4d7142b66a525ea4909ff", response_type: 'token', scope: 'heartrate', redirect_uri: "redirect_urlがhttp://localhost:3000/auth/fitbit_oauth2/callbackに飛ばされてしまう"
#  provider :fitbit_oauth2, "227YDT", "d2c2fdd07deb12a78f2b6cbed91dbbcf", response_type: 'code', scope: 'profile heartrate', redirect_uri: "http://localhost:3000/auth/fitbit_oauth2/callback", expires_in: '2592000'
  # provider :fitbit_oauth2, "227YDT", "d2c2fdd07deb12a78f2b6cbed91dbbcf", response_type: 'code', scope: 'profile heartrate', redirect_uri: "http://localhost:3000/auth/fitbit_oauth2/callback", expires: false
  # provider :fitbit_oauth2, "227YDT", "d2c2fdd07deb12a78f2b6cbed91dbbcf", response_type: 'code', scope: 'profile heartrate', redirect_uri: "http://localhost:3000/auth/fitbit_oauth2/callback", expires_in: "259200"
  # heroku update
  provider :fitbit_oauth2, ENV["FITBIT_API_KEY"], ENV["FITBIT_API_SECRET"], response_type: 'code', scope: 'profile heartrate', redirect_uri: "http://heart-beat-tweet.herokuapp.com/auth/fitbit_oauth2/callback", expires_in: "259200"
end