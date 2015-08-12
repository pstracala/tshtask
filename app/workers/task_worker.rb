class TaskWorker
  include Sidekiq::Worker
  
  
  def perform
    exchange = Exchange.new
    is_saved = exchange.save_current_rates
    if is_saved.present?
      User.find_each do |user|
        UserMailer.new_rates_mail(user).deliver
      end
      puts 'Exchange rates have been updated.'
    else
      puts 'Exchange rates are up-to-date.'
    end
  end
  
  #Sidekiq::Cron::Job.create(name: 'Refresh exchange rates everyday at 13', cron: '0 13 * * * *', klass: 'TaskWorker') 
  # in tasks but redis doesn't work on Heroku
end