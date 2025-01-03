class PasswordsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:email])
    if @user
      # Gera um token temporário
      token = SecureRandom.hex(10)
      @user.update(reset_password_token: token, reset_password_sent_at: Time.current)

      # Redireciona para a página de redefinição
      redirect_to edit_password_path(token: token), notice: "Por favor, defina sua nova senha."
    else
      flash.now[:alert] = "Email não encontrado."
      render :new
    end
  end

  def edit
    @user = User.find_by(reset_password_token: params[:token])

    unless @user && token_valid?(@user)
      redirect_to new_password_path, alert: "Link de recuperação inválido ou expirado."
    end
  end

  def update
    @user = User.find_by(reset_password_token: params[:token])

    if @user && token_valid?(@user)
      if @user.update(password_params)
        @user.update(reset_password_token: nil, reset_password_sent_at: nil)
        redirect_to new_user_session_path, notice: "Senha alterada com sucesso! Por favor, faça login."
      else
        render :edit
      end
    else
      redirect_to new_password_path, alert: "Link de recuperação inválido ou expirado."
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def token_valid?(user)
    user.reset_password_sent_at && user.reset_password_sent_at > 1.hour.ago
  end
end
