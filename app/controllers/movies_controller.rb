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
    @all_ratings = Movie.all_ratings
    @check_box_ratings = @all_ratings
    @movies = Movie.all
    movies_not_sorted = @movies
    curr_session = {}
    curr_params = {}
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @check_box_ratings = params[:ratings].keys
      @movies = Movie.where(:rating => @check_box_ratings)
      movies_not_sorted = @movies
    end
    if params[:sort_by] == "title"
      @title_header = "hilite"
      session[:sort_by] = "title"
      session[:sorted_by] = ""
      @movies = movies_not_sorted.order(:title)
    elsif params[:sorted_by] == "release date"
      @release_date_header = "hilite"
      session[:sorted_by] = "release date"
      session[:sort_by] = ""
      @movies = movies_not_sorted.order(:release_date)
    end
    [:ratings, :sort_by, :sorted_by].each do |index|
      if session[index]
        curr_session[index] = session[index]
      end
      if params[index]
        curr_params[index] = params[index]
      end
    end
    if curr_session != curr_params
        flash.keep
        redirect_to movies_path(curr_session)
    end
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
