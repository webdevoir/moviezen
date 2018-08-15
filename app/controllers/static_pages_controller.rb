class StaticPagesController < ApplicationController
  def home
    now_playing = Category.where(slug: 'now_playing').first
    upcoming = Category.where(slug: 'upcoming').first
    popular = Category.where(slug: 'popular').first
    top_rated = Category.where(slug: 'top_rated').first

    @categories = [now_playing, upcoming, popular, top_rated]
  end
end
