class UsersController < ApplicationController
  access_resource users: [:name]

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

end
