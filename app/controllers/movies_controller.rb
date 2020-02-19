class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.order(params[:sort])
    mysort = params[:sort] or session[:sort]
    if mysort == 'title'
      olist = {:title => :asc}
      @para_title = 'hilite'
    elsif mysort == 'release_date'
      olist = {:release_date => :asc}
      @para_release = 'hilite'
    end
    
    @all_ratings = Movie.all_ratings
    @get_rating = params[:ratings] or session[:ratings] or {}
    
    if @get_rating == {}
      @get_rating = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort]
      session[:sort] = params[:sort]
    elsif params[:ratings] != session[:ratings]
      session[:ratings] = params[:ratings]
    end
    
    @movies = Movie.where(rating: @get_rating.keys).order(olist)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
