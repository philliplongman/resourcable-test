class ProfilesController < ApplicationController
  before_action :set_user
  before_action :set_profile

  respond_to :html

  def show
  end

  def new
  end

  def create
    @profile.update(profile_params)
    respond_with @profile, location: -> { user_profile_path(@profile.user) }
  end

  def edit
  end

  def update
    @profile.update(profile_params)
    respond_with @profile, location: -> { user_profile_path(@profile.user) }
  end

  def destroy
    @profile.destroy
    respond_with(@user)
  end

  private
    def set_user
      @user = User.find(params[:user_id])
    end

    def set_profile
      @profile = Profile.find_or_initialize_by(user: @user)
    end

    def profile_params
      params.require(:profile).permit(:display_name)
    end
end
