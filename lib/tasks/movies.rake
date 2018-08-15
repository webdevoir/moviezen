namespace :movies do
  desc 'Aggregate movies for the front page'
  task :aggregate => :environment do
    puts 'Aggregating movies...'

    tmdb = Tmdb.new 
    tmdb_config = tmdb.config
    @tmdb_image_prefix = ''

    unless tmdb_config.nil?
      @tmdb_image_prefix = tmdb_config['images']['secure_base_url'] unless tmdb_config['images'].nil?
    end

    get_movies('Now Playing', 'now_playing')
    delay
    get_movies('Upcoming', 'upcoming')
    delay
    get_movies('Popular', 'popular')
    delay
    get_movies('Top Rated', 'top_rated')

    puts 'Movies aggregated.'
  end

  task :parse_json => :environment do
    puts 'Parsing json movies...'

    start = Time.now
    movies = []

    File.open('storage/movie_ids_08_14_2018.json').each do |line|
      movie = JSON.parse(line)
      movies.push(movie)
    end

    stop = Time.now
    elapsed = stop - start

    puts "Elapsed time: #{elapsed}s"
    puts "Total movie count: #{movies.count}"

    estimated_time = ((movies.count / 40) * 10) / 60 / 60
    puts "Estimated time to store movies: #{estimated_time}h"
  end

  def delay
    puts "Waiting 10s for rate limit..."
    sleep 10
    puts "Continuing..."
  end
  
  def get_movies(category_title, category_slug)
    category = Category.where(title: category_title, slug: category_slug).first_or_create
    category.movies.delete_all

    tmdb = Tmdb.new 
    omdb = Omdb.new

    tmdb_response = tmdb.movie(category_slug)
    total_results = tmdb_response['total_results']
    puts "Total results: #{total_results} for #{category_slug}"
    tmdb_results = tmdb_response['results']

    unless tmdb_results.nil?
      tmdb_results.each do |result|
        tmdb_id = result['id']
        tmdb_movie = tmdb.movie(tmdb_id, 'release_dates,videos')
        release_date = tmdb_movie['release_date']
        year = release_date.nil? ? '' : release_date.to_date.strftime('%Y')
        title = tmdb_movie['title']
        slug = title.nil? ? '' : "#{tmdb_id}-#{title.parameterize}"

        movie_attrs = {
          title: title,
          year: year,
          slug: slug,
          poster_url: '',
          backdrop_url: '',
          tagline: tmdb_movie['tagline'],
          overview: tmdb_movie['overview'],
          release_date: release_date,
          runtime: tmdb_movie['runtime'],
          trailer_key: '',
          certification: '',
          tomato_rating: '',
          imdb_rating: '',
          metacritic_rating: '',
          tmdb_vote_count: tmdb_movie['vote_count'],
          tmdb_vote_avg: tmdb_movie['vote_average'],
          imdb_id: tmdb_movie['imdb_id']
        }

        # Add poster and backdrop url
        poster_path = tmdb_movie['poster_path']
        backdrop_path = tmdb_movie['backdrop_path']

        unless poster_path.nil?
          movie_attrs[:poster_url] = @tmdb_image_prefix + 'w342' + poster_path
        end

        unless backdrop_path.nil?
          movie_attrs[:backdrop_url] = @tmdb_image_prefix + 'original' + backdrop_path
        end

        # Get first youtube trailer key
        videos = tmdb_movie['videos']
        trailer_key = ''
        unless videos.nil?
          videos['results'].each do |video|
            if video['type'] == 'Trailer' && video['site'] == 'YouTube'
              trailer_key = video['key']
              break
            end
          end
        end
        movie_attrs[:trailer_key] = trailer_key

        # Get the US certification as default
        release_dates = tmdb_movie['release_dates']
        certification = ''
        unless release_dates.nil?
          release_dates['results'].each do |r|
            if r['iso_3166_1'] == 'US'
              certification = r['release_dates'].first['certification']
              break
            end
          end
        end
        movie_attrs[:certification] = certification

        # Get OMDB data
        imdb_id = movie_attrs[:imdb_id]
        omdb_movie = omdb.movie_by_id(imdb_id)
        omdb_ratings = omdb_movie['Ratings']
        unless omdb_ratings.nil?
          omdb_ratings.each do |rating|
            case rating['Source']
            when 'Rotten Tomatoes'
              movie_attrs[:tomato_rating] = rating['Value'].to_f
            when 'Internet Movie Database'
              movie_attrs[:imdb_rating] = rating['Value'].to_f
            when 'Metacritic'
              movie_attrs[:metacritic_rating] = rating['Value'].to_f
            end
          end
        end
        movie = Movie.find_or_initialize_by(tmdb_id: tmdb_id)
        movie.attributes = movie_attrs
        movie.save
        movie.categories << category unless movie.categories.include?(category)

        genres = tmdb_movie['genres']

        unless genres.nil?
          genres.each do |genre|
            genre_name = genre['name']
            genre = Genre.where(name: genre_name).first_or_create
            movie.genres << genre unless movie.genres.include?(genre)
          end
        end

        # Store the credits
        # credits = tmdb_movie['credits']
        # cast = credits['cast']
        # crew = credits['crew']

        # unless cast.nil?
        #   cast.each do |cast_member|
        #     person = Person.find_or_initialize_by(tmdb_id: cast_member['id'])
        #     person.name = cast_member['name']
        #     profile_path = cast_member['profile_path']

        #     unless profile_path.nil?
        #       person.profile_url = @tmdb_image_prefix + 'w185' + profile_path
        #     end

        #     person.save

        #     credit_id = cast_member['credit_id']

        #     Credit.where(credit_id: credit_id).first_or_create do |credit|
        #       credit.character = cast_member['character']
        #       credit.cast_id = cast_member['cast_id']
        #       credit.order = cast_member['order']
        #       credit.person = person
        #       credit.movie = movie
        #     end
        #   end
        # end

        # unless crew.nil?
        #   crew.each do |crew_member|
        #     person = Person.find_or_initialize_by(tmdb_id: crew_member['id'])
        #     person.name = crew_member['name']
        #     profile_path = crew_member['profile_path']

        #     unless profile_path.nil?
        #       person.profile_url = @tmdb_image_prefix + 'w185' + profile_path
        #     end

        #     person.save

        #     credit_id = crew_member['credit_id']

        #     Credit.where(credit_id: credit_id).first_or_create do |credit|
        #       credit.department = crew_member['department']
        #       credit.job = crew_member['job']
        #       credit.person = person
        #       credit.movie = movie
        #     end
        #   end
        # end
        
      end
    end
  end

end
