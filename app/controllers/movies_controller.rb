class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:ratings] == nil and params[:order] == nil
      params[:ratings] = session[:ratings]
      params[:order] = session[:order]
    else
      session.clear
    end
    @all_ratings = Movie.all_ratings
    puts(params[:ratings])
    if params[:ratings] == nil
      @ratings_to_show = []
    else
      @ratings_to_show = params[:ratings].keys
    end
    if @ratings_to_show == []
      @movies = Movie.all
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    order = params[:order]
    if order == 'title'
      @movies = @movies.order(:title)
      @title_class = 'bg-warning hilite'
    end
    if order == 'date'
      @movies = @movies.order(:release_date)
      @date_class = 'bg-warning hilite'
    end
    session[:ratings] = params[:ratings]
    session[:order] = params[:order]
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
