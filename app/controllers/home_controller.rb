class HomeController < ApplicationController
  
  def index
    #Sidekiq::Cron::Job.create(name: 'Refresh exchange rates everyday at 13', cron: '0 13 * * * *', klass: 'TaskWorker')
  end
end
