class RegistrationsController < Devise::RegistrationsController
  # 登録時の画面
  # こっちは使われない
  # def after_sign_up_path_for(resource)
  #   binding.pry
  # end

  # 仮登録時に飛ぶURLを書く（確認メールを送ったあとの送信画面）
  def after_inactive_sign_up_path_for(resource)
    "/users/confirm"
  end
end