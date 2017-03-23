class PostsController < ApplicationController
  access_resources User
  access_resources Post, columns: [:title]

  def index
    posts
  end

  def show
    post
  end

  def new
    post
  end

  def create
    post.save
    respond_with post, location: -> { user_post_path(user, post) }
  end

  def edit
    post
  end

  def update
    post.save
    respond_with post, location: -> { user_post_path(user, post) }
  end

  def destroy
    post.destroy
    respond_with posts, location: -> { user_posts_path(user) }
  end

  private

  def post_params
    params.require(:post).permit(:title)
  end
end
