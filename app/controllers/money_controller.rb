class MoneyController < ApplicationController

  def index
    #show list of exchange rates with creation time
    #don't forget about pagination
  end

  def show
    #show table of currencies for selected exchange rate
  end

  def refresh_rates
    #for manual refreshing
    #get latest exchange rates and save to db
    #can be helpful: 
    #http://www.nbp.pl/home.aspx?f=/kursy/instrukcja_pobierania_kursow_walut.html
    exchange = Exchange.new
    is_saved = exchange.save_current_rates
    if is_saved.present?
      render js: "alert('Rates have been updated.');"
    else
      render js: "alert('Rates are up-to-date.');"
    end
  end

  def report
    #generate a report for selected currency
    #report should show: basic statistics: mean, median, average
    #also You can generate a simple chart(use can use some js library)

    #this method should be available only for currencies which exist in the database 
  end


end
