class SaveToDatabaseJob < ApplicationJob
  queue_as :default

  def perform(user_ip, query)

    # *initial_query, last = search_query.split
    # initial_query = initial_query.join(" ")
    
    #   prevSearchLog = SearchLog.where(user_ip: user_ip, query: initial_query).take
    #   if prevSearchLog
    #     prevSearchLog.delete
    #   end
    #   searchLog = SearchLog.where(user_ip: user_ip, query: search_query).take
    #   if searchLog
    #     prevSearchLog.update(count: searchLog.count + 1)
    #     SearchLog.create(user_ip: user_ip, query: search_query, count: 1)
    #   end
    

    # Do something later
    
    if query != ""
      ActiveRecord::Base.transaction do 
        lastSearchLog = SearchLog.where(user_ip: user_ip).last
        if lastSearchLog
          if query[0..-2].include? lastSearchLog.query
            lastSearchLog.update(query: query)
          else
            SearchLog.create(user_ip: user_ip, query: query)
          end
        else 
          SearchLog.create(user_ip: user_ip, query: query)
        end
      end
    end
  end
end
