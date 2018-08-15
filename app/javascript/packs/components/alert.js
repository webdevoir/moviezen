import React from 'react'
import PropTypes from 'prop-types'
import { UncontrolledAlert } from 'reactstrap'

const Alert = ({ type, message }) => (
  <UncontrolledAlert color={type}>{message}</UncontrolledAlert>
)

Alert.propTypes = {
  type: PropTypes.oneOf(['success', 'danger']),
  message: PropTypes.any
}

export default Alert
