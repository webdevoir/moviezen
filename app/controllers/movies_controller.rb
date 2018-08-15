class MoviesController < ApplicationController
  include MoviesHelper

  def show
    slug = params[:id]
    tmdb_id = slug.split('-')[0]
    @movie = Movie.find_by(tmdb_id: tmdb_id)
    if @movie.nil?
      @movie = save_tmdb_movie(tmdb_id)
      if @movie.nil?
        raise ActionController::RoutingError.new('Not Found')
      end
    end

    @movie_hash = @movie.attributes
    @movie_hash[:genres] = @movie.genres
    @movie_hash[:released] = @movie_hash['release_date'].strftime('%b %-d, %Y')
    @movie_hash[:credits] = @movie.credits

    cast = []
    directors = []
    writers = []

    tmdb = Tmdb.new
    credits = tmdb.movie_credits(tmdb_id)
    profile_base_url = 'https://image.tmdb.org/t/p/w185'
    if credits.key?('cast')
      cast = credits['cast']
      cast.each do |c|
        profile_path = c['profile_path']
        c['profile_url'] = profile_path.nil? ? '' : profile_base_url + profile_path
      end
    end
    if credits.key?('crew')
      credits['crew'].each do |crew_member|
        department = crew_member['department']
        if department == 'Directing'
          directors.push(crew_member)
        elsif department == 'Writing'
          writers.push(crew_member)
        end
      end
    end

    @movie_hash[:cast] = cast
    @movie_hash[:directors] = directors
    @movie_hash[:writers] = writers

    isFavorite = false
    isWatchlist = false

    if current_user
      isFavorite = current_user.movies.where({ 
        user_movies: { is_favorite: true, movie_id: @movie.id } 
      }).count > 0
      isWatchlist = current_user.movies.where({
        user_movies: { is_watchlist: true, movie_id: @movie.id } 
      }).count > 0
    end

    render react_component: 'MoviePage', props: { movie: @movie_hash, currentUser: current_user, isFavorite: isFavorite, isWatchlist: isWatchlist }
  end

  # Handle the search form submit
  def search
    #@movies = Movie.where('title LIKE :search', search: "%#{query}%")
    @movies = search_tmdb(true)
  end

  # Autosuggest search
  def search_suggest
    @movies = search_tmdb
    render json: @movies
  end

  def search_tmdb(to_object = false)
    query = params[:query]
    poster_base_url = 'https://image.tmdb.org/t/p/w342'
    tmdb = Tmdb.new
    search_response = tmdb.search(query)
    results = search_response['results']
    @movies = []
    results.each do |movie|
      movie['year'] = movie['release_date'].blank? ? '' : movie['release_date'].to_date.strftime('%Y')
      movie['poster_url'] = movie['poster_path'].blank? ? '' : poster_base_url + movie['poster_path']
      if to_object
        movie = OpenStruct.new(movie)
      end
      @movies.push(movie)
    end
    return @movies
  end

  def search_movies
    query = params[:query]
    @movies = Movie.where('title LIKE :search', search: "%#{query}%").limit(10)
  end
end
