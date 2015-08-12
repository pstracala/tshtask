class TaskWorker
  include Sidekiq::Worker
  
  
  def perform
    exchange = Exchange.new
    is_saved = exchange.save_current_rates
    if is_saved.present?
      puts 'Exchange rates have been updated.'
    else
      puts 'Exchange rates are up-to-date.'
    end
  end
end