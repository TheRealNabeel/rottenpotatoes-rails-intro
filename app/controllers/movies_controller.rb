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
    if params[:ratings]
      @check_box_ratings = params[:ratings].keys
      @movies = Movie.where(:rating => @check_box_ratings)
      movies_not_sorted = @movies
    end
    if params[:sort_by] == "title"
      @title_header = "hilite"
      @movies = movies_not_sorted.order(:title)
    elsif params[:sort_by] == "release date"
      @release_date_header = "hilite"
      @movies = movies_not_sorted.order(:release_date)
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
