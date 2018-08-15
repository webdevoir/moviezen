namespace :scrape do

  desc 'Scrape movies from RottenTomatoes'
  task :movies => :environment do
    puts 'Scraping movies...'

    scrape_rotten('Opening', 'opening')
    scrape_rotten('Top Box Office', 'in-theaters')
    scrape_rotten('Coming Soon', 'upcoming')
    scrape_rotten('Certified Fresh Movies', 'cf-in-theaters')

    puts 'Movies scraped.'
  end
  
  def scrape_rotten(title, slug)
    url = "https://www.rottentomatoes.com/browse/#{slug}/"
    scraper = WebScraper.new

    doc = scraper.get_page(url)
    movie_titles = doc.css('.mb-movie .movie_info .movieTitle')
    movie_ratings = doc.css('.mb-movie .movie_info .tMeterScore')
    movie_link = doc.css('.mb-movie .movie_info a')

    category = Category.where(title: title, slug: slug).first_or_create
    category.movies.delete_all

    tmdb = Tmdb.new
    tmdb_config = tmdb.get_config
    tmdb_image_prefix = tmdb_config['images']['secure_base_url']

    omdb = Omdb.new
    trakt = Trakt.new

    movie_titles.each_with_index do |item, index|
      title = item.text
      tomato_rating = movie_ratings[index].nil? ? '' : movie_ratings[index].text
      tomato_slug = movie_links[index].nil? ? nil : movie_links[index]['href']
      year = tomato_slug.split('_').last.to_i unless tomato_slug.nil?
      omdb_result = omdb.movie_by_title(title, year)
      unless omdb_result.nil? || omdb_result["Response"] == 'False'
        imdb_id = omdb_result['imdbID']
        trakt_response = trakt.movie_by_imdb_id(imdb_id)
        trakt_result = trakt_response.first unless trakt_response.nil?
        unless trakt_result.nil?
          movie_data = {
            title: trakt_result['movie']['title'],
            year: trakt_result['movie']['year'],
            trakt_id: trakt_result['movie']['ids']['trakt'],
            imdb_id: trakt_result['movie']['ids']['imdb'],
            tmdb_id: trakt_result['movie']['ids']['tmdb'],
            slug: trakt_result['movie']['ids']['slug'],
            tagline: trakt_result['movie']['tagline'],
            overview: trakt_result['movie']['overview'],
            released: trakt_result['movie']['released'],
            runtime: trakt_result['movie']['runtime'],
            trailer: trakt_result['movie']['trailer'],
            updated_at: trakt_result['movie']['updated_at'],
            certification: trakt_result['movie']['certification'],
            trakt_rating: trakt_result['movie']['rating'],
            tomato_rating: tomato_rating,
            poster: '',
            backdrop: '',
          }

          omdb_poster = omdb_result['Poster']
          unless omdb_poster.nil? || omdb_poster == 'N/A'
            movie_data[:poster] = omdb_poster
          end

          tmdb_movie = tmdb.get_movie(movie_data[:tmdb_id])
          poster_path = tmdb_movie['poster_path']
          backdrop_path = tmdb_movie['backdrop_path']

          # Use the TMDB poster if OMDB doesn't have the poster
          if movie_data[:poster].nil?
            unless poster_path.nil?
              movie_data[:poster] = tmdb_image_prefix + 'w342' + poster_path
            end
          end
          unless backdrop_path.nil?
            movie_data[:backdrop] = tmdb_image_prefix + 'original' + backdrop_path 
          end
          movie = Movie.find_or_initialize_by(trakt_id: movie_data[:trakt_id])
          movie.attributes = movie_data
          movie.save
          movie.categories << category unless movie.categories.include?(category)

          genres = trakt_result['movie']['genres']
          genres.each do |genre_slug|
            genre_name = genre_slug.split('-').map(&:capitalize).join(' ')
            genre = Genre.where(slug: genre_slug, name: genre_name).first_or_create
            movie.genres << genre unless movie.genres.include?(genre)
          end
        end
      end
    end
  end

end
