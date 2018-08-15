class Omdb
  include HTTParty
  base_uri 'omdbapi.com'

  def initialize
    @apikey = Rails.application.credentials.omdb[:api_key] 
  end

  def movie_by_id(id)
    options = { query: { apikey: @apikey, i: id, type: 'movie' } }
    self.class.get("/", options)
  end

  def movie_by_title(title, year = nil)
    options = { query: { apikey: @apikey, t: title, y: year, type: 'movie' } }
    self.class.get("/", options)
  end
  
  def search_movies(s)
    options = { query: { apikey: @apikey, s: s, type: 'movie' } }
    self.class.get("/", options)
  end
end
