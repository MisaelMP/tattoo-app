class SessionController < ApplicationController
  # These pages should be accessible without login
  skip_before_action :current_user, except: [:logout]
  
  # This controller action shows the login and signup page
  def form_login_signup
    @user = User.new
  rescue => e
    Rails.logger.error "Error in form_login_signup: #{e.message}"
    flash[:error] = "An error occurred. Please try again."
    redirect_to root_path
  end

  # This controller action process the data entered on the SIGNUP form
  def process_signup
    @user = User.new user_params
    
    begin
      if @user.save
        Rails.logger.info "User created successfully: #{@user.id}"
        
        if params['profile_image']
          begin
            cloudinary = Cloudinary::Uploader.upload(params['profile_image'])
            @user.profile_image = cloudinary['url']
            Rails.logger.info "Profile image uploaded successfully"
          rescue => e
            Rails.logger.error "Cloudinary upload error: #{e.message}"
            @user.profile_image = 'https://www.goaltos.com/wp-content/uploads/sites/4559/2018/01/avatar-1577909_960_720.png'
          end
        else
          @user.profile_image = 'https://www.goaltos.com/wp-content/uploads/sites/4559/2018/01/avatar-1577909_960_720.png'
        end
        
        @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Thanks for joining #{@user.name}"
        redirect_to root_path
      else
        Rails.logger.error "User save failed: #{@user.errors.full_messages.join(', ')}"
        flash[:error] = @user.errors.full_messages.join(', ')
        render :form_login_signup
      end
    rescue => e
      Rails.logger.error "Error in process_signup: #{e.message}"
      flash[:error] = "An error occurred during signup. Please try again."
      render :form_login_signup
    end
  end

  # This controller action process the data entered on the LOGIN form
  def process_login
    begin
      user = User.find_by :email => params[:email]
      if user.present? && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect_to root_path
      else
        flash[:error] = "Invalid email or password"
        redirect_to login_path
      end
    rescue => e
      Rails.logger.error "Error in process_login: #{e.message}"
      flash[:error] = "An error occurred during login. Please try again."
      redirect_to login_path
    end
  end
  
  # This is the action to which the user sign-out delete request is posted.
  def logout
    session[:user_id] = nil
    flash[:notice] = "You have logged out."
    redirect_to root_path
  end

  private
  def user_params
    params.permit(
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
      :is_artist )
  end
end
