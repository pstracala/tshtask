class Exchange < ActiveRecord::Base
  has_many :currencies

  require 'nokogiri'
  require 'open-uri'


  def get_nbp_xml
    Nokogiri::XML(open("http://www.nbp.pl/kursy/xml/LastC.xml"))
  end

  def save_current_rates
    xml_file = get_nbp_xml
    date = xml_file.at_xpath('//data_publikacji').content
    exchange = Exchange.find_by_name(date)
    
    unless exchange.present?
      self.name = date
      xml_file.xpath('//pozycja').each do |pozycja|
        self.currencies.new(name: pozycja.at_xpath('nazwa_waluty').content,
                            converter: pozycja.at_xpath('przelicznik').content,
                            code: pozycja.at_xpath('kod_waluty').content,
                            buy_price: pozycja.at_xpath('kurs_kupna').content.gsub!(',', '.').to_f, 
                            sell_price: pozycja.at_xpath('kurs_sprzedazy').content.gsub!(',', '.').to_f)
      end
      self.save
    end
  end
end
