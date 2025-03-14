class PlacesController < ApplicationController
before_action :require_login

  def index
    @places = Place.all
  end

  def show
    @place = Place.find_by({ "id" => params["id"] })
    @entries = Entry.where({ "place_id" => @place["id"], "user_id" => session["user_id"] })
  end

  def new
  end

  def create
    @place = Place.new
    @place["name"] = params["name"]
    @place.save
    redirect_to "/places"
  end
  private

  def require_login
    unless session[:user_id]
      flash[:alert] = "You must be logged in to access this page."
      redirect_to login_path  # ✅ Redirect to login if not logged in
    end
  end
end
