class CommentsController < ApplicationController
  access_resources :users
  access_resources :posts
  access_resources :comments

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
    comment.update(comment_params)
    respond_with comment, location: -> { user_post_comment_path(user, post, comment) }
  end

  def edit
    comment
  end

  def update
    comment.update(comment_params)
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
