import React, { Component } from 'react'
import styled from 'react-emotion'
import MdSearch from 'react-icons/lib/md/search'
import Autosuggest from 'react-autosuggest'
import axios from 'axios'
import { SearchForm, SearchBox } from './styled'
import placeholder from '../utils/placeholder'
import spinner from '../assets/spinner.svg'

class Search extends Component {
  constructor(props) {
    super(props)

    this.state = {
      query: '',
      suggestions: [],
      isLoading: false
    }

    this.lastRequestTimer = null
  }

  loadSuggestions(value) {
    // Cancel the previous request
    if (this.lastRequestTimer !== null) {
      clearTimeout(this.lastRequestTimer)
    }

    this.setState({
      isLoading: true
    })

    this.lastRequestTimer = setTimeout(() => {
      axios({
        method: 'POST',
        url: '/movies/search_suggest',
        data: { query: value },
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name=csrf-token]')
            .content
        }
      }).then(res => {
        console.log(res)
        this.setState({
          isLoading: false,
          suggestions: res.data
        })
      })
    }, 1000)
  }

  onChange = (event, { newValue }) => {
    this.setState({
      query: newValue
    })
  }

  onSuggestionsFetchRequested = ({ value }) => {
    this.loadSuggestions(value)
  }

  onSuggestionsClearRequested = () => {
    this.setState({
      suggestions: []
    })
  }

  getSuggestionValue(suggestion) {
    return suggestion.title
  }

  renderSuggestion(suggestion) {
    return (
      <a href={`/movies/${suggestion.id}`} className="media link-normal">
        {suggestion.poster_url && (
          <img
            className="mr-3 suggestion-img"
            src={suggestion.poster_url}
            alt={suggestion.title}
          />
        )}
        <div className="media-body align-self-center">
          <h5 className="mt-0 suggestion-title">
            {suggestion.title}
            <small className="year year-dark">({suggestion.year})</small>
          </h5>
        </div>
      </a>
    )
  }

  render() {
    const { query, suggestions, isLoading } = this.state
    const inputProps = {
      className: 'form-control w-100',
      name: 'query',
      placeholder: 'Search for movies',
      value: query,
      onChange: this.onChange
    }

    return (
      <SearchForm className="form-inline" action="/movies/search" method="get">
        <SearchBox>
          <Autosuggest
            suggestions={suggestions}
            onSuggestionsFetchRequested={this.onSuggestionsFetchRequested}
            onSuggestionsClearRequested={this.onSuggestionsClearRequested}
            getSuggestionValue={this.getSuggestionValue}
            renderSuggestion={this.renderSuggestion}
            inputProps={inputProps}
          />
        </SearchBox>
        <div className="search-icon">
          <MdSearch size={24} />
        </div>
        {isLoading && <img src={spinner} className="spinner" />}
      </SearchForm>
    )
  }
}

export default Search
