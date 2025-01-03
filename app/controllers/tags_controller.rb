class TagsController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :check_admin, except: [:show]

  def index
    @tags = Tag.all
  end

  def show
    @posts = @tag.posts.includes(:user, :tags).order(created_at: :desc).page(params[:page]).per(3)
  end

  def new
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    if @tag.save
      redirect_to tags_path, notice: 'Tag criada com sucesso.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @tag.update(tag_params)
      redirect_to tags_path, notice: 'Tag atualizada com sucesso.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @tag.destroy
    redirect_to tags_path, notice: 'Tag excluída com sucesso.'
  end

  private

  def set_tag
    @tag = Tag.find(params[:id])
  end

  def tag_params
    params.require(:tag).permit(:name)
  end

  def check_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'Acesso negado.'
    end
  end
end