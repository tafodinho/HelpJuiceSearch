class SearchController < ApplicationController
  def index
    @searches = SearchLog.group(:query).count.sort_by { |_, count| -count }.take(10)
  end

  def analytics
    @searches = SearchLog.group(:query).count.sort_by { |_, count| -count }.take(10)
    render json: {searches: @searches}
  end

  def search
    # Retrieve and display search analytics
    search_query = params[:query]
    @user_ip = request.remote_ip
    *initial_query, last = search_query.split
    initial_query = initial_query.join(" ")
    

    synchronize_database do 
      searchLog = SearchLog.where(user_ip: @user_ip, query: initial_query).take
      print "HELLO HERE #{searchLog}"
      if searchLog
        searchLog.update(query: search_query)
      else
        SearchLog.create(user_ip: @user_ip, query: search_query)
      end
    end
   
  end

  def synchronize_database
    # Use synchronize block to ensure only one transaction is processed at a time
    Rails.application.executor.wrap do
      ActiveRecord::Base.connection_pool.with_connection do
        ActiveRecord::Base.connection.transaction do
          yield
        end
      end
    end
  end
end
