class HomeController < ApplicationController
  
  def index
    #TaskWorker.perform_in(30.seconds)
    puts Sidekiq::Cron::Job.create(name: 'Hard worker - every 1 min', cron: '*/1 * * * *', klass: 'TaskWorker')
  end
end
