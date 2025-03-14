class EntriesController < ApplicationController

  def index
    @entires = Entry.all 

    respond_to do |format|
      format.html 
      format.json { render json: @entries }
    end
  end

  def new
    @user = User.find_by({ "id" => session["user_id"] })
  end

  def create
    @user = User.find_by({ "id" => session["user_id"] })  # ✅ Find the logged-in user

    if @user
      @entry = Entry.new
      @entry["title"] = params["title"]
      @entry["description"] = params["description"]
      @entry["occurred_on"] = params["occurred_on"]
      @entry["place_id"] = params["place_id"]
      @entry["user_id"] = @user["id"]

      if params["uploaded_image"].present?  # ✅ Only attach image if provided
        @entry.uploaded_image.attach(params["uploaded_image"])
      end

      @entry.save
    else
      flash["notice"] = "Login first."
    end

    redirect_to "/places/#{@entry["place_id"]}"
  end

  # ✅ Removes security restrictions for API calls
  def allow_cors
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, PATCH, DELETE, OPTIONS'
    response.headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token, Auth-Token, Email, X-User-Token, X-User-Email'
    response.headers['Access-Control-Max-Age'] = '1728000'
  end

  private

  def require_login
    unless session[:user_id]
      flash[:alert] = "You must be logged in to access"
      redirect_to login_path
    end
  end
end
