import styled from 'react-emotion'
import shadows from '../utils/shadows'

const Backdrop = styled('div')`
  border-radius: 1px;
  position: relative;
  padding-bottom: 1rem;
  margin-bottom: 1rem;

  /* Parallax Effect */
  background-attachment: fixed;
  background-repeat: no-repeat;
  background-position: 50% 10%;
  background-size: cover;

  &:before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(0, 0, 0, 0.5);
  }
  @media (min-width: 992px) {
    padding-top: 20rem;
  }
`

const Poster = styled('img')`
  box-shadow: ${shadows['8']};
  width: 100%;
  max-width: 200px;
  @media (min-width: 768px) {
    position: absolute;
    max-width: 150px;
  }
  @media (min-width: 992px) {
    max-width: 200px;
  }
  @media (min-width: 1200px) {
    max-width: 250px;
  }
`

const Title = styled('h1')`
  color: rgba(255, 255, 255, 0.9);
  font-weight: 400;
  font-size: 25px;

  @media (min-width: 768px) {
    font-size: 40px;
  }
`

const Actions = styled('div')`
  margin-top: 2em;
  color: rgba(255, 255, 255, 0.9);

  .text-muted {
    color: rgba(255, 255, 255, 0.8) !important;
  }

  .btn {
    background: transparent;
    color: rgba(255, 255, 255, 0.9);
    margin-bottom: 1em;
    svg {
      height: 24px;
      width: 24px;
      margin-right: 5px;
      color: rgba(255, 255, 255, 0.9);
    }
    &:hover {
      svg {
        color: rgba(255, 255, 255, 1);
      }
    }
  }
`

export { Backdrop, Poster, Title, Actions }
