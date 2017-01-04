class UsersController < ApplicationController
  def show
    @tweets = current_user.tweets.page(params[:page]).per(5).order("created_at DESC")
  end

  def confirm
  end

  def edit
  end

  def update
    current_user.update(update_params)
  end

  def fitbit_revoke
    token = Usertoken.find_by(user_id: current_user[:id])
    access_token = token[:access_token]
    token.destroy
  end

  private
  def update_params
    params.require(:user).permit(:avatar)
  end
end