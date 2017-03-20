class PostsController < ApplicationController
  before_action :set_user
  before_action :set_post

  respond_to :html

  def index
  end

  def show
  end

  def new
  end

  def create
    @post.update(post_params)
    respond_with @post, location: -> { user_post_path(@user, @post) }
  end

  def edit
  end

  def update
    @post.update(post_params)
    respond_with @post, location: -> { user_post_path(@user, @post) }
  end

  def destroy
    @post.destroy
    respond_with @posts, location: -> { user_posts_path(@user) }
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_post
    if params[:action] == 'index'
      @posts = Post.all
    else
      @post = Post.find_or_initialize_by(id: params[:id])
      @post.user_id = params[:user_id]
      @post
    end
  end

  def post_params
    params.require(:post).permit(:title)
  end

end
