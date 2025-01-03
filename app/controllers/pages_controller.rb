class PagesController < ApplicationController
  def home
    # Aqui você pode adicionar qualquer lógica necessária para a página inicial
    @latest_posts = Post.includes(:user, :tags)
                       .order(created_at: :desc)
                       .limit(3)
  end
end
