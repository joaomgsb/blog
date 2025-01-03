class HomeController < ApplicationController
  def index
    @latest_posts = Post.includes(:user, :tags)
                       .order(created_at: :desc)
                       .limit(3)
  end
end