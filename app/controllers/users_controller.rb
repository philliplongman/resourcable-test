class UsersController < ApplicationController
  access_resource :users

  def index
    users
  end

  def show
    user
  end

  def new
    user
  end

  def create
    user.update(user_params)
    respond_with user
  end

  def edit
    user
  end

  def update
    user.update(user_params)
    respond_with user
  end

  def destroy
    user.destroy
    respond_with user
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
