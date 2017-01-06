class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    access_token = auth_hash.credentials.token
    refresh_token = auth_hash.credentials.refresh_token
    expires_at = Time.zone.at(auth_hash.credentials.expires_at)
    # DBに保存する
    Usertoken.create(user_id: current_user.id, access_token: access_token, refresh_token: refresh_token, expires_at: expires_at)
    redirect_to "/users/fitbit_register"
  end
end