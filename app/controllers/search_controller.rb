

# app/controllers/search_controller.rb

class SearchController < ApplicationController
  before_action :initialize_cache

  def index
    # @searches = SearchLog.order(count: :desc).take(10)
    @searches = SearchLog.group(:query).count.sort_by { |_, count| -count }.take(100)
  end

  def search
    query = params[:query].to_s.strip
    @user_ip = request.remote_ip

    if query.present?
      # Check if the new query has the same words as the cached query except the last one
      update_cache(query)
    end
    render json: { status: 'success' }
  end

  def save_cached_data_to_database
    @user_ip = request.remote_ip
    cache_content = Rails.cache.read(cache_key)
    # Enqueue a background job to save the cache content to the database
    SaveToDatabaseJob.perform_later(@user_ip, cache_content)

    # Update the cache with the new query
    Rails.cache.delete(cache_key)
  end

  def analytics
    @searches = SearchLog.group(:query, :user_ip).count.sort_by { |_, count| -count }.take(10)
    render "analytics"
  end

  private

    def initialize_cache
      # Initialize the cache with an empty string if it's not already set
      Rails.cache.write(cache_key, '') unless Rails.cache.read(cache_key)
    end

    def cache_key
      # You may want to use a unique identifier for each user, such as IP address or session ID
      "user_#{request.remote_ip}_search_cache"
    end

    def update_cache(query)
      # Update the cache with the new query
      Rails.cache.write(cache_key, query)
    end

end
