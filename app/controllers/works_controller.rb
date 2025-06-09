class WorksController < ApplicationController
  before_action :authorize, :except => [:index]
  
  def index
    @works = Work.all
  rescue => e
    Rails.logger.error "Error in works#index: #{e.message}"
    render json: { error: 'An error occurred' }, status: :internal_server_error
  end

  def new
    @work = Work.new
  end

  def show
    @work = Work.find params[:id]
  end

  def edit
    @work = Work.find params[:id]
    unless @current_user.works.include? @work
      redirect_to root_path
    else
      render :edit
    end
  end

  def update
    work = Work.find params[:id]
    unless @current_user.works.include? work
      redirect_to root_path, alert: 'Not authorized'
      return
    end
    
    if work.update work_params
      if params['work']['artwork_image']
        begin
          cloudinary = Cloudinary::Uploader.upload(params['work']['artwork_image'])
          work.artwork_image = cloudinary['url']
          work.save
        rescue => e
          Rails.logger.error "Error uploading image: #{e.message}"
          flash[:error] = "Error uploading image"
          redirect_to edit_work_path(work)
          return
        end
      end
      redirect_to work
    else
      render :edit
    end
  rescue => e
    Rails.logger.error "Error in works#update: #{e.message}"
    flash[:error] = "An error occurred"
    redirect_to edit_work_path(work)
  end

  def create
    work = current_user.works.build work_params
    if params['work']['artwork_image']
      cloudinary = Cloudinary::Uploader.upload(params['work']['artwork_image'])
      work.artwork_image = cloudinary['url']
    end
    if work.save
      flash[:success] =  "ArtWork Created!"
      redirect_to work
    else
      @work = work
      render :new
    end
  end

  def destroy
    work = Work.find params[:id]
    work.destroy if @current_user.works.include? work
    flash[:success] =  "ArtWork has been Deleted!"
    redirect_to works_path
  end

  # Strong params: create a whitelist of permitted parameters
private
def work_params
  params.require(:work).permit(:title, :price, :category, :artwork_image)
end
end
