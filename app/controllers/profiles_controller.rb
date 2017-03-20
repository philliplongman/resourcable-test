class ProfilesController < ApplicationController
  access_resources :users
  access_resource :profile

  def show
    profile
  end

  def new
    profile
  end

  def create
    profile.update(profile_params)
    respond_with profile, location: -> { user_profile_path(profile.user) }
  end

  def edit
    profile
  end

  def update
    profile.update(profile_params)
    respond_with profile, location: -> { user_profile_path(profile.user) }
  end

  def destroy
    profile.destroy
    respond_with profile, location: -> { user_path(user) }
  end

  private

  def profile_params
    params.require(:profile).permit(:display_name)
  end
end
