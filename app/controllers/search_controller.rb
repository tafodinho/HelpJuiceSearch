# class SearchController < ApplicationController
#   def index
#     @searches = SearchLog.order(count: :desc).take(10)
#   end

#   def analytics
#     @searches = SearchLog.group(:query).count.sort_by { |_, count| -count }.take(10)
#     render json: {searches: @searches}
#   end

#   def search
#     # Retrieve and display search analytics
#     search_query = params[:query]
#     @user_ip = request.remote_ip
#     # SaveToDatabaseJob.perform_later(@user_ip, search_query)
#     if is_complete_search(search_query)?
#       SearchLog.update(user_ip: @user_ip, query: search_query)
#     else
#       SearchLog.create(user_ip: @user_ip, query: search_query)
#     end
#   end

#   def is_complete_search?(query)
#     return false if query.blank?
#     return true if @previous_search.nil? || query.split[0..-2].join(" ") != @previous_search
#     false
#   end

#   def load_previous_search
#     @previous_search = SearchLog.where(user_ip: @user_ip).last&.query
#   end
# end

# class SearchController < ApplicationController
#   def index
#     @searches = SearchLog.group(:query).count.sort_by { |_, count| -count }.take(10)
#   end

#   def analytics
#     @searches = SearchLog.group(:query).count.sort_by { |_, count| -count }.take(10)
#     render json: {searches: @searches}
#   end

#   def search
#     # Retrieve and display search analytics
#     search_query = params[:query]
#     @user_ip = request.remote_ip
    

#     synchronize_database do 
#       *initial_query, last = search_query.split
#       initial_query = initial_query.join(" ")
#       searchLog = SearchLog.where(user_ip: @user_ip, query: initial_query).take
#       print "HELLO HERE #{searchLog}"
#       if searchLog
#         searchLog.update(query: search_query)
#       else
#         SearchLog.create(user_ip: @user_ip, query: search_query)
#       end
#     end
   
#   end

#   def synchronize_database
#     # Use synchronize block to ensure only one transaction is processed at a time
#     Rails.application.executor.wrap do
#       ActiveRecord::Base.connection_pool.with_connection do
#         ActiveRecord::Base.connection.transaction do
#           yield
#         end
#       end
#     end
#   end
# end

# app/controllers/search_controller.rb

class SearchController < ApplicationController
  before_action :initialize_cache

  def index
    # @searches = SearchLog.order(count: :desc).take(10)
    @searches = SearchLog.group(:query).count.sort_by { |_, count| -count }.take(10)
    # Rails.logger.info("QUERIES #{@searches[9].query}")
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

  private

    def initialize_cache
      # Initialize the cache with an empty string if it's not already set
      Rails.cache.write(cache_key, '') unless Rails.cache.read(cache_key)
    end

    def cache_key
      # You may want to use a unique identifier for each user, such as IP address or session ID
      "user_#{request.remote_ip}_search_cache"
    end

    def is_incomplete_query?(new_query)
      words_in_cache = Rails.cache.read(cache_key)
      words_in_new_query = new_query
      
      # Check if all words except the last one are the same
      # Rails.logger.info("FIRST #{words_in_cache} == #{words_in_new_query[0...-1]}")
      # Rails.logger.info("COMPARE #{words_in_cache == words_in_new_query[0..-2]}")
      words_in_cache == words_in_new_query[0..-2]
    end

    def update_cache(query)
      # Update the cache with the new query
      Rails.cache.write(cache_key, query)
    end

end
