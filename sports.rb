require 'open-uri'
require 'nokogiri'
require 'httparty'
require 'byebug'
require 'telegram/bot'
require 'json'



	token = '914704234:AAHLIJIQ2KTImvFz9DuWJEUMY0DfpomBFus'
 	url = 'https://www.sports.ru/football/?from=menu&e=main'
	unparsed_page = HTTParty.get(url)

	parsed_page = Nokogiri::HTML(unparsed_page)
	items = Array.new
	
	item_cards = parsed_page.css('ul.teaser')

	item_cards.each do |item_card|

			whe = item_card.css('div.teaser-event__status span')[0].text
			where = item_card.css('.teaser-event__tv').text
			who = item_card.css('.teaser-event__board-player-name')[0].text
			who2 = item_card.css('.teaser-event__board-player-name')[1].text
			score = item_card.css('.teaser-event__board-score').text
		
		item = [
		   "Время матча: #{whe},
			Где посмотреть: #{where},
			Играют #{who} с #{who2},
			Результат матча: #{score}"
		]
		
		items << item
	end

	Telegram::Bot::Client.run(token) do |bot|
  		bot.listen do |message|
    		case message.text
   			when '/start'
      			bot.api.sendMessage(chat_id: message.chat.id,
      			 text: "Hello, #{message.from.first_name}\n#{items.to_s.tr('"tn[','').tr('\\','').tr(",]","\n\n")}")
    		end
  		end
	end
  		


  
 
  


