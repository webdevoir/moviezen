import React from 'react'
import ReactDOM from 'react-dom'
import PropTypes from 'prop-types'
import MovieThumb from './components/movie_thumb'

const MovieList = ({ movies }) => (
  <div className="row">
    {movies.map(movie => (
      <div className="col-md-3" style={{ paddingBottom: 30 }} key={movie.id}>
        <MovieThumb movie={movie} />
      </div>
    ))}
  </div>
)

MovieList.propTypes = {
  movies: PropTypes.arrayOf(Object)
}

export default MovieList
