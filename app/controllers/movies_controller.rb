class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort_by = params[:sort_by]
    filter_ratings = params[:ratings]
    @all_ratings = Movie.get_all_ratings
    if filter_ratings == nil
      if session[:r] == nil
        @r = @all_ratings
      else
        @r = session[:r]
      end
    else
      if filter_ratings.is_a?(Hash)
        @r = filter_ratings.keys
      elsif filter_ratings.is_a?(Array)
        @r = filter_ratings
      end
    end
    if sort_by == nil 
      @movies = Movie.where(:rating => @r)
      if session[:sort_by] == nil
        @hilite = nil
      else
        sort_by = session[:sort_by]
        flash.keep
        redirect_to movies_path(:sort_by => sort_by, :r => @r)
      end
    else
      @hilite = sort_by
      if sort_by == 'title'
        @movies = Movie.order(:title).where(:rating => @r) 
      elsif sort_by == 'release_date'
        @movies = Movie.order(:release_date).where(:rating => @r)
      end
    end
    session[:r] = @r 
    session[:sort_by] = sort_by
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
