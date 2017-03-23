class UsersController < ApplicationController
  access_resource :users, columns: [:name]

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
    user.save
    respond_with user
  end

  def edit
    user
  end

  def update
    user.save
    respond_with user
  end

  def destroy
    user.destroy
    respond_with user
  end

end
