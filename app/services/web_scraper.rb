require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: false})
end

class WebScraper
  include Capybara::DSL

  def get_page(url)
    visit(url)
    doc = Nokogiri::HTML(page.html)
    return doc
  end
end
