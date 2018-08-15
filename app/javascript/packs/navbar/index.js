import React, { Component } from 'react'
import PropTypes from 'prop-types'
import Search from './search'
import {
  UncontrolledDropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem
} from 'reactstrap'

class Navbar extends Component {
  constructor(props) {
    super(props)
    this.state = { showMenu: false }
    this.toggleMenu = this.toggleMenu.bind(this)
  }

  toggleMenu() {
    this.setState({ showMenu: !this.state.showMenu })
  }

  render() {
    const { showMenu } = this.state
    const { currentUser } = this.props
    return (
      <nav className="navbar navbar-expand-md fixed-top flex-md-nowrap navbar-light bg-white shadow">
        <div className="container">
          <div className="col-3">
            <a className="navbar-brand" href="/">
              moviezen
            </a>
          </div>
          <button
            onClick={this.toggleMenu}
            className="navbar-toggler"
            type="button"
            data-toggle="collapse"
            data-target="#navbarNavDropdown"
            aria-controls="navbarNavDropdown"
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-icon" />
          </button>
          <div
            className={`collapse navbar-collapse ${showMenu && 'show'}`}
            id="navbarNavDropdown"
          >
            <div className="col-md-8">
              <Search />
            </div>
            {!currentUser ? (
              <ul className="navbar-nav ml-auto">
                <li className="nav-item">
                  <a className="nav-link" href="/users/sign_in">
                    Log in
                  </a>
                </li>
                <li className="nav-item">
                  <a className="nav-link" href="/users/sign_up">
                    Sign up
                  </a>
                </li>
              </ul>
            ) : (
              <ul className="navbar-nav ml-auto">
                <ProfileDropdown currentUser={currentUser} />
              </ul>
            )}
          </div>
        </div>
      </nav>
    )
  }
}

const ProfileDropdown = ({ currentUser }) => (
  <UncontrolledDropdown nav inNavbar>
    <DropdownToggle nav caret>
      {currentUser.name.split(' ')[0]}
    </DropdownToggle>
    <DropdownMenu right>
      <DropdownItem href="/users/edit">Edit Profile</DropdownItem>
      <DropdownItem href={`/user_movies/${currentUser.id}?type=favorites`}>
        Favorites
      </DropdownItem>
      <DropdownItem href={`/user_movies/${currentUser.id}?type=watchlist`}>
        Watchlist
      </DropdownItem>
      <DropdownItem divider />
      <DropdownItem rel="nofollow" data-method="delete" href="/users/sign_out">
        Log out
      </DropdownItem>
    </DropdownMenu>
  </UncontrolledDropdown>
)

Navbar.propTypes = {
  currentUser: PropTypes.object
}

export default Navbar
