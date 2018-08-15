import React, { Component } from 'react'
import PropTypes from 'prop-types'
import FaStar from 'react-icons/lib/fa/star'
import FaPlay from 'react-icons/lib/fa/play'
import FaHeart from 'react-icons/lib/fa/heart'
import FaEye from 'react-icons/lib/fa/eye'
import ReactTooltip from 'react-tooltip'
import { Backdrop, Poster, Title, Actions } from './styled'
import Trailer from '../components/trailer'
import formatDate from '../utils/formatDate'
import axios from 'axios'
import CastCarousel from './cast_carousel'

class MoviePage extends Component {
  constructor(props) {
    super(props)
    this.state = {
      showTrailer: false,
      isFavorite: false,
      isWatchlist: false
    }
    this.toggleTrailer = this.toggleTrailer.bind(this)
    this.toggleFavorite = this.toggleFavorite.bind(this)
    this.toggleWatchlist = this.toggleWatchlist.bind(this)
  }

  toggleTrailer(e) {
    this.setState({
      showTrailer: !this.state.showTrailer
    })
  }

  toggleFavorite() {
    const { currentUser, movie } = this.props
    const { isFavorite } = this.state
    if (currentUser) {
      axios({
        method: 'PUT',
        url: '/user_movies/' + currentUser.id,
        data: { movie_id: movie.id, is_favorite: !isFavorite },
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name=csrf-token]')
            .content
        }
      }).then(res => {
        this.setState({
          isFavorite: !isFavorite
        })
      })
    } else {
      window.location = '/users/sign_in'
    }
  }

  toggleWatchlist() {
    const { currentUser, movie } = this.props
    const { isWatchlist } = this.state
    if (currentUser) {
      axios({
        method: 'PUT',
        url: '/user_movies/' + currentUser.id,
        data: { movie_id: movie.id, is_watchlist: !isWatchlist },
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name=csrf-token]')
            .content
        }
      }).then(res => {
        console.log(res.data)
        this.setState({
          isWatchlist: !isWatchlist
        })
      })
    } else {
      window.location = '/users/sign_in'
    }
  }

  componentDidMount() {
    console.log(this.props.movie)
    const { isFavorite, isWatchlist } = this.props
    this.setState({ isFavorite, isWatchlist })
  }

  render() {
    const { movie, currentUser } = this.props
    const { showTrailer, isFavorite, isWatchlist } = this.state

    let style = {}
    if (movie.backdrop_url) {
      style.backgroundImage = `url(${movie.backdrop_url})`
    }
    return (
      <div>
        <Backdrop className="jumbotron" style={style}>
          <div className="container">
            <div className="row">
              <div className="col-4 col-md-3">
                <Poster src={movie.poster_url} alt={movie.title} />
              </div>
              <div className="col-8 col-md-8 align-self-end">
                <Title>
                  {movie.title}
                  {movie.year && <small className="year">({movie.year})</small>}
                </Title>
                <div className="ratings">
                  {movie.tomato_rating && (
                    <a
                      href={`https://www.rottentomatoes.com/m/${movie.slug
                        .split('-')
                        .slice(1)
                        .join('_')}`}
                      target="_blank"
                      className="rating"
                      data-tip="Tomatometer"
                    >
                      <img
                        className="tomato-icon"
                        src="/assets/icons8-tomato-50.png"
                      />
                      <span className="rating-num">
                        {movie.tomato_rating}
                        <small>%</small>
                      </span>
                    </a>
                  )}
                  {movie.tmdb_vote_avg > 0 && (
                    <div className="rating" data-tip="TMDB Vote Average">
                      <FaStar size={20} color="#f5de50" />
                      <span className="rating-num">
                        {movie.tmdb_vote_avg.toFixed(1)}
                      </span>
                    </div>
                  )}
                </div>
                <div className="container">
                  <Actions className="row">
                    <div className="col-xs-12">
                      {movie.trailer_key ? (
                        <button
                          onClick={this.toggleTrailer}
                          type="button"
                          className="btn btn-light"
                        >
                          <FaPlay /> Watch Trailer
                        </button>
                      ) : (
                        <p className="lead text-muted">No trailer yet</p>
                      )}
                    </div>
                    <div className="spacer" />
                    <div className="col-xs-12">
                      <button
                        type="button"
                        className="btn btn-icon"
                        data-tip={`${isFavorite ? 'Unfavorite' : 'Favorite'}`}
                        onClick={this.toggleFavorite}
                      >
                        <FaHeart color={isFavorite ? 'rgb(255,45,85)' : ''} />
                      </button>
                      <button
                        type="button"
                        className="btn btn-icon"
                        data-tip={`${
                          isWatchlist
                            ? 'Remove from watchlist'
                            : 'Add to watchlist'
                        }`}
                        onClick={this.toggleWatchlist}
                      >
                        <FaEye color={isWatchlist ? 'rgb(76,217,100)' : ''} />
                      </button>
                      <ReactTooltip delayShow={500} effect="solid" />
                    </div>
                  </Actions>
                </div>
              </div>
            </div>
          </div>
        </Backdrop>
        <div className="container">
          <div className="row">
            <div className="col col-lg-3" />
            <div className="col-lg-8">
              <p className="lead mb-4">{movie.overview}</p>
              <p className="mb-1">
                <strong>Directed by:</strong>{' '}
                {movie.directors
                  .slice(0, 2)
                  .map(d => d.person.name)
                  .join(', ')}
              </p>
              <p className="mb-1">
                <strong>Starring:</strong>{' '}
                {movie.cast
                  .slice(0, 4)
                  .map(c => c.person.name)
                  .join(', ')}
              </p>
              <p className="mb-1">
                <strong>Written by:</strong>{' '}
                {movie.writers
                  .slice(0, 2)
                  .map(w => w.person.name)
                  .join(', ')}
              </p>
              <p className="mb-1">
                <strong>Released:</strong> {formatDate(movie.release_date)}
              </p>
              {movie.runtime && (
                <p className="mb-1">
                  <strong>Runtime:</strong> {movie.runtime}
                </p>
              )}
              <p className="mb-1">
                <strong>Genres:</strong>{' '}
                {movie.genres.map(g => g.name).join(', ')}
              </p>

              <h3 className="mt-5">Cast</h3>
              <hr />
              <CastCarousel cast={movie.cast} />
            </div>
          </div>
        </div>
        {movie.trailer_key && (
          <Trailer
            show={showTrailer}
            videoSrc={`https://www.youtube.com/embed/${movie.trailer_key}`}
            toggleTrailer={this.toggleTrailer}
          />
        )}
      </div>
    )
  }
}

MoviePage.propTypes = {
  movie: PropTypes.object,
  currentUser: PropTypes.object,
  isFavorite: PropTypes.bool,
  isWatchlist: PropTypes.bool
}

export default MoviePage
