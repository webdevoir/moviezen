import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Modal from './modal'
import MdClose from 'react-icons/lib/md/close'
import styled from 'react-emotion'

class Trailer extends Component {
  render() {
    const { show, toggleTrailer, videoSrc } = this.props
    return (
      <Modal>
        <div
          onClick={toggleTrailer}
          className={`modal fade ${show ? 'show' : ''}`}
          style={{ display: show ? 'block' : 'none' }}
        >
          <div className="modal-dialog modal-dialog-centered modal-lg">
            <div className="modal-content" style={{ background: 'black' }}>
              {show && (
                <div className="embed-responsive embed-responsive-16by9">
                  <iframe
                    className="embed-responsive-item"
                    src={videoSrc + '?autoplay=1&rel=0'}
                    frameBorder="0"
                    allow="autoplay; encrypted-media"
                    allowFullScreen
                  />
                </div>
              )}
              <CloseButton onClick={toggleTrailer}>
                <MdClose color="white" size={30} />
              </CloseButton>
            </div>
          </div>
        </div>
        <div
          style={{ display: show ? 'block' : 'none' }}
          className={`modal-backdrop darker fade ${show ? 'show' : ''}`}
        />
      </Modal>
    )
  }
}

const CloseButton = styled('button')`
  background: transparent;
  border: none;
  opacity: 0.6;
  position: absolute;
  right: 0px;
  top: -40px;
  cursor: pointer;

  &:hover {
    opacity: 0.8;
  }

  &:focus {
    outline: 0;
  }

  @media (min-width: 768px) {
    right: -40px;
  }
`

Trailer.defaultProps = {
  show: false
}

Trailer.propTypes = {
  videoSrc: PropTypes.string,
  show: PropTypes.bool,
  toggleTrailer: PropTypes.func
}

export default Trailer
