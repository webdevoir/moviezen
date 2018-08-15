class Tmdb
  include HTTParty
  base_uri 'api.themoviedb.org/3'
  
  def initialize
    @api_key = Rails.application.credentials.tmdb[:api_key]
  end

  def movie(id, append_to_response = '')
    options = { query: { api_key: @api_key, append_to_response: append_to_response } }
    self.class.get("/movie/#{id}", options)
  end

  def config
    options = { query: { api_key: @api_key } }
    self.class.get("/configuration", options)
  end

  def search(q)
    options = { query: { api_key: @api_key, query: q } }
    self.class.get("/search/movie", options)
  end

  def movie_credits(movie_id)
    options = { query: { api_key: @api_key } }
    self.class.get("/movie/#{movie_id}/credits", options)
  end
end
