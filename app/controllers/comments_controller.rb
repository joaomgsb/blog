class CommentsController < ApplicationController
    before_action :set_post
    before_action :authenticate_user!, only: [ :destroy ]
    before_action :check_owner, only: [ :destroy ]

    def create
      @comment = @post.comments.build(comment_params)
      @comment.user = current_user if user_signed_in?

      if @comment.save
        redirect_to @post, notice: "Comentário adicionado com sucesso."
      else
        redirect_to @post, alert: "Erro ao adicionar comentário."
      end
    end

    def destroy
      @comment = @post.comments.find(params[:id])
      @comment.destroy
      redirect_to @post, notice: "Comentário excluído com sucesso."
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def comment_params
      params.require(:comment).permit(:content, :author_name)
    end

    def check_owner
      @comment = @post.comments.find(params[:id])
      unless current_user == @comment.user
        redirect_to @post, alert: "Você não tem permissão para esta ação."
      end
    end
end
