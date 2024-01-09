Rails.application.config.after_initialize do
  # scheduler = Rufus::Scheduler.new

  # scheduler.every '10s' do
  #   user_ip = request.remote_ip
  #   data_to_write = Rails.cache.read("user_#{user_ip}_search_cache")
  #   SaveToDatabaseJob.perform_later(user_ip, data_to_write)
  #   Rails.cache.write("user_#{request.remote_ip}_search_cache", '')
  # end
end