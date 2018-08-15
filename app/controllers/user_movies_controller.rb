class UserMoviesController < ApplicationController
  before_action :authenticate_user!, only: [:update]

  # Show a user's movies, can be favorites or watchlist
  def show
    @user = User.find_by(id: params[:id])
    type = params[:type]

    @movies = []
    @page_title = ''

    if type == 'watchlist'
      @movies = @user.movies.where({ user_movies: { is_watchlist: true } })
      if @user == current_user
        @page_title = 'Your Watchlist'
      else
        @page_title = "#{@user.name.split(' ')[0]}'s Watchlist"
      end
    else
      if @user == current_user
        @page_title = 'Your Favorites'
      else
        @page_title = "#{@user.name.split(' ')[0]}'s Favorites"
      end
      @movies = @user.movies.where({ user_movies: { is_favorite: true } })
    end
  end

  # Update user's movies, favorite or watchlist
  def update
    user_id = params[:id]
    movie_id = params[:movie_id]
    is_favorite = params[:is_favorite] 
    is_watchlist = params[:is_watchlist]

    user_movie = UserMovie.where(user_id: user_id, movie_id: movie_id).first_or_create 

    if !is_favorite.nil?
      user_movie.is_favorite = is_favorite
    else !is_watchlist.nil?
      user_movie.is_watchlist = is_watchlist
    end
    user_movie.save
  end

end
