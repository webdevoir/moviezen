import React from 'react'
import PropTypes from 'prop-types'
import Carousel from 'nuka-carousel'
import MovieThumb from './components/movie_thumb'
import CarouselNextButton from './components/carousel_next_button'
import CarouselPreviousButton from './components/carousel_previous_button'

const getSlidesToShow = () => {
  let slidesToShow = 3
  if (window.matchMedia('(min-width: 768px)').matches) {
    slidesToShow = 5
  }
  return slidesToShow
}

const MovieCarousel = ({ movies }) => (
  <Carousel
    slidesToShow={getSlidesToShow()}
    slidesToScroll={3}
    cellSpacing={20}
    renderCenterLeftControls={props => <CarouselPreviousButton {...props} />}
    renderCenterRightControls={props => <CarouselNextButton {...props} />}
    renderBottomCenterControls={() => {}}
  >
    {movies.map(movie => (
      <MovieThumb movie={movie} key={movie.id} />
    ))}
  </Carousel>
)

MovieCarousel.propTypes = {
  movies: PropTypes.arrayOf(Object)
}

export default MovieCarousel
