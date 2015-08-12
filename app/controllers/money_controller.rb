class MoneyController < ApplicationController
  before_filter :authenticate_user!

  def index
    #show list of exchange rates with creation time
    #don't forget about pagination
    @exchanges = Exchange.paginate(:page => params[:page], :per_page => 10)
  end

  def show
    #show table of currencies for selected exchange rate
    @exchange = Exchange.find(params[:id])
    @currencies = @exchange.currencies
  end

  def refresh_rates
    #for manual refreshing
    #get latest exchange rates and save to db
    #can be helpful: 
    #http://www.nbp.pl/home.aspx?f=/kursy/instrukcja_pobierania_kursow_walut.html
    exchange = Exchange.new
    is_saved = exchange.save_current_rates
    if is_saved.present?
      User.find_each do |user|
        UserMailer.new_rates_mail(user).deliver
      end
      #redirect_to money_index_path, notice: 'Rates have been updated.'
      render js: "alert('Rates have been updated.');"
    else
      #redirect_to money_index_path, notice: 'Rates are up-to-date.'
      render js: "alert('Rates are up-to-date.');"
    end
  end

  def report
    #generate a report for selected currency
    #report should show: basic statistics: mean, median, average
    #also You can generate a simple chart(use can use some js library)

    #this method should be available only for currencies which exist in the database 
    @currency = Currency.find_by_id(params[:id])
    if @currency.present?
      selected_currency_history = Currency.where(name: @currency.name)
      buy_price_history = selected_currency_history.pluck(:buy_price)
      sell_price_history = selected_currency_history.pluck(:sell_price)
      @average_sell_price = sell_price_history.sum / sell_price_history.size
      @average_buy_price = buy_price_history.sum / buy_price_history.size
      buy_price_history_sorted = buy_price_history.sort
      sell_price_history_sorted = sell_price_history.sort
      @median_buy_price = (buy_price_history_sorted[(buy_price_history.length - 1) / 2] + buy_price_history_sorted[buy_price_history.length / 2]) / 2.0
      @median_sell_price = (sell_price_history_sorted[(sell_price_history.length - 1) / 2] + sell_price_history_sorted[sell_price_history.length / 2]) / 2.0
    end
  end
  
  def history
    @currency_history = Currency.where(name: params[:name])
    @labels = Exchange.all.pluck(:name)

    @sell_price_history = @currency_history.pluck(:sell_price)
    @buy_price_history = @currency_history.pluck(:buy_price)
    @currency_history = @currency_history.paginate(:page => params[:page], :per_page => 10)
  end


end
