class CommentsController < ApplicationController
  before_action :set_user
  before_action :set_post
  before_action :set_comment

  respond_to :html

  def index
  end

  def show
  end

  def new
  end

  def create
    @comment.update(comment_params)
    respond_with @comment, location: -> { user_post_comment_path(@user, @post, @comment) }
  end

  def edit
  end

  def update
    @comment.update(comment_params)
    respond_with @comment, location: -> { user_post_comment_path(@user, @post, @comment) }
  end

  def destroy
    @comment.destroy
    respond_with @comments, location: -> { user_post_comments_path(@user, @post) }
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    if params[:action] == 'index'
      @comments = Comment.all
    else
      @comment = Comment.find_or_initialize_by(id: params[:id])
      @comment.post_id = params[:post_id]
      @comment
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
