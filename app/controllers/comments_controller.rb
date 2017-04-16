class CommentsController < ApplicationController
  access_resources :posts, :users
  access_resources :comments, decorater: true, columns: [:body]

  def index
    comments
  end

  def show
    comment
  end

  def new
    comment
  end

  def create
    comment.save
    respond_with comment, location: -> { user_post_comment_path(user, post, comment) }
  end

  def edit
    comment
  end

  def update
    comment.save
    respond_with comment, location: -> { user_post_comment_path(user, post, comment) }
  end

  def destroy
    comment.destroy
    respond_with comments, location: -> { user_post_comments_path(user, post) }
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
