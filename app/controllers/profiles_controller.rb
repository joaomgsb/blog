class ProfilesController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  before_action :set_user, only: [ :show ]

  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to profile_path(current_user.username), notice: "Perfil atualizado com sucesso!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def edit_password
  end

  def update_password
    if current_user.update_with_password(password_params)
      bypass_sign_in(current_user)
      redirect_to profile_path(current_user.username), notice: "Senha alterada com sucesso!"
    else
      render :edit_password, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by!(username: params[:username])
  end

  def user_params
    params.require(:user).permit(:avatar, :username, :name, :bio, :website, :location)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
