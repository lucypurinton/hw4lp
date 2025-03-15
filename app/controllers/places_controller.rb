class PlacesController < ApplicationController
before_action :require_login

  def index
    @places = Place.where({"user_id" => session["user_id"]})
  end

  def show
    @place = Place.find_by({ "id" => params["id"], "user_id" => session["user_id"] })
    if @place.nil?
      flash[:alert] = "You do not have access"
      redirect_to "/places"
    else 
      @entries = Entry.where({ "place_id" => @place["id"], "user_id" => session["user_id"] })
    end 
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new
    @place["name"] = params["name"]
    @place["user_id"] = session["user_id"]
    @place.save
    redirect_to "/places"
  end
  private

  def require_login
    unless session[:user_id]
      flash[:alert] = "Log in to access"
      redirect_to login_path  
    end
  end
end
