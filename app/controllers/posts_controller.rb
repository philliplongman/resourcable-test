class PostsController < ApplicationController
  access_resources :users
  access_resources :posts

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
    post.update(post_params)
    respond_with post, location: -> { user_post_path(user, post) }
  end

  def edit
    post
  end

  def update
    post.update(post_params)
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
