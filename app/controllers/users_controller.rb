class UsersController < ApplicationController
  before_action :authorize
  
  def show
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "User not found: #{e.message}"
    flash[:error] = "User not found"
    redirect_to root_path
  rescue => e
    Rails.logger.error "Error in show: #{e.message}"
    flash[:error] = "An error occurred"
    redirect_to root_path
  end

  def new
    @user = User.new
  rescue => e
    Rails.logger.error "Error in new: #{e.message}"
    flash[:error] = "An error occurred"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    begin
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Thanks for joining #{@user.name}"
        redirect_to root_path
      else
        Rails.logger.error "User creation failed: #{@user.errors.full_messages.join(', ')}"
        flash[:error] = @user.errors.full_messages.join(', ')
        render :new
      end
    rescue => e
      Rails.logger.error "Error in create: #{e.message}"
      flash[:error] = "An error occurred during signup"
      render :new
    end
  end

  def edit
    @user = @current_user
  rescue => e
    Rails.logger.error "Error in edit: #{e.message}"
    flash[:error] = "An error occurred"
    redirect_to root_path
  end

  def update
    begin
      user = User.find params[:id]
      unless user == @current_user
        redirect_to root_path, alert: 'Not authorized'
        return
      end

      if user.update user_params
        if params['user']['profile_image']
          begin
            cloudinary = Cloudinary::Uploader.upload(params['user']['profile_image'])
            user.profile_image = cloudinary['url']
            user.save
          rescue => e
            Rails.logger.error "Cloudinary upload error: #{e.message}"
            flash[:error] = "Error uploading profile image"
          end
        end
        redirect_to user
      else
        Rails.logger.error "User update failed: #{user.errors.full_messages.join(', ')}"
        flash[:error] = user.errors.full_messages.join(', ')
        render :edit
      end
    rescue => e
      Rails.logger.error "Error in update: #{e.message}"
      flash[:error] = "An error occurred"
      redirect_to edit_user_path(@current_user)
    end
  end

  def destroy
   user = User.find params[:id]
   user.destroy
   redirect_to root_path
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
