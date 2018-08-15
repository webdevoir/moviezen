import React from 'react'
import Carousel from 'nuka-carousel'
import CarouselPreviousButton from '../components/carousel_previous_button'
import CarouselNextButton from '../components/carousel_next_button'
import styled from 'react-emotion'

const getSlidesToShow = () => {
  let slidesToShow = 3
  if (window.matchMedia('(min-width: 768px)').matches) {
    slidesToShow = 5
  }
  return slidesToShow
}

const CastCarousel = ({ cast }) => (
  <StyledCarousel
    framePadding="0 0 50px 0"
    slidesToShow={getSlidesToShow()}
    slidesToScroll={3}
    cellSpacing={20}
    renderCenterLeftControls={props => null}
    renderCenterRightControls={props => null}
    renderBottomCenterControls={() => null}
  >
    {cast.map(castMember => (
      <CastMember key={castMember.id}>
        {castMember.profile_url && (
          <img src={castMember.profile_url} alt={castMember.name} />
        )}
        {castMember.name} <br />
        as <em>{castMember.character}</em>
      </CastMember>
    ))}
  </StyledCarousel>
)

const StyledCarousel = styled(Carousel)`
  .slider-list {
    cursor: default !important;
  }
`

const CastMember = styled('div')`
  max-width: 150px;
  cursor: default;

  img {
    max-width: 100%;
    margin-bottom: 10px;
  }
`

export default CastCarousel
