class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]
  before_action :check_owner, only: [:edit, :update, :destroy]

  def index
    Rails.logger.debug "=== DEBUG: Listagem de Posts ==="
    Rails.logger.debug "Timezone da aplicação: #{Time.zone.name}"
    Rails.logger.debug "Hora atual: #{Time.current}"
    Rails.logger.debug "Usuário atual: #{current_user&.email}"
    
    @posts = Post.includes(:user, :tags).order(created_at: :desc)
    Rails.logger.debug "Total de posts no banco: #{@posts.count}"
    Rails.logger.debug "IDs dos posts: #{@posts.pluck(:id)}"
    Rails.logger.debug "Posts com timestamps:"
    @posts.each do |post|
      Rails.logger.debug "- Post #{post.id}: #{post.title} (criado em: #{post.created_at}, #{post.created_at.zone})"
    end
    
    @posts = @posts.page(params[:page]).per(3)
    Rails.logger.debug "Posts na página atual: #{@posts.size}"
    Rails.logger.debug "IDs dos posts paginados: #{@posts.pluck(:id)}"
    
    if @posts.any?
      Rails.logger.debug "Primeiro post:"
      Rails.logger.debug "- ID: #{@posts.first.id}"
      Rails.logger.debug "- Título: #{@posts.first.title}"
      Rails.logger.debug "- Autor: #{@posts.first.user.username}"
      Rails.logger.debug "- Conteúdo: #{@posts.first.content.truncate(100)}"
    end
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.includes(:user).newest_first
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to @post, notice: 'Post criado com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to @post, notice: 'Post atualizado com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'Post excluído com sucesso.'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, tag_ids: [])
  end

  def check_owner
    unless @post.user == current_user
      redirect_to posts_path, alert: 'Você não tem permissão para esta ação.'
    end
  end
end