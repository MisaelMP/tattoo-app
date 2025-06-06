class UsersController < ApplicationController
  before_action :authorize
  def show
    @user = User.find params[:id]
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Thanks for joining #{@user.name}"
      redirect_to root_path # Redirect to home if the account is valid
    else
      render :new # Let them retry the form again
    end
  end

  def edit
    @user = @current_user
  end

  def update
    user = User.find params[:id]
    unless user == @current_user
      redirect_to root_path, alert: 'Not authorized'
      return
    end
    user.update user_params
    if params['user']['profile_image']
      cloudinary = Cloudinary::Uploader.upload(params['user']['profile_image'])
      user.profile_image = cloudinary['url']
    else
      user.profile_image = 'https://www.goaltos.com/wp-content/uploads/sites/4559/2018/01/avatar-1577909_960_720.png'
    end
    if user.save
      redirect_to user
    else
      @user = user
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :name,
      :password,
      :password_confirmation,
      :user_name,
      :name,
      :profile_image,
      :location,
      :phone,
      :blurb,
      :is_artist
    )
  end
end
