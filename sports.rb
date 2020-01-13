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
foots = Array.new
	
foot_cards = parsed_page.css('li.teaser-event')

foot_cards.each do |foot_card|

	whe = foot_card.css('div.teaser-event__status span')[0].text
	where = foot_card.css('.teaser-event__tv').text
	who = foot_card.css('.teaser-event__board-player-name')[0].text
	who2 = foot_card.css('.teaser-event__board-player-name')[1].text
	score = foot_card.css('.teaser-event__board-score').text
		
	foot = [
	   "Время матча: #{whe},
		Где посмотреть: #{where},
		Играют #{who} с #{who2},
		Результат матча: #{score}"
	]
		
		foots << foot
end

url = 'https://www.sports.ru/basketball/?from=menu&e=main'
unparsed_page = HTTParty.get(url)

parsed_page = Nokogiri::HTML(unparsed_page)
baskets = Array.new
	
basket_cards = parsed_page.css('li.teaser-event')

basket_cards.each do |basket_card|

	wheb = basket_card.css('div.teaser-event__status span')[0].text
	whereb = basket_card.css('.teaser-event__tv').text
	whob = basket_card.css('.teaser-event__board-player-name')[0].text
	who2b = basket_card.css('.teaser-event__board-player-name')[1].text
	scoreb = basket_card.css('.teaser-event__board-score').text
		
	basket = [
	   "Время матча: #{wheb},
		Где посмотреть: #{whereb},
		Играют #{whob} с #{who2b},
		Результат матча: #{scoreb}"
	]
		
		baskets << basket
end

url = 'https://sport.ua/'
unparsed_page = HTTParty.get(url)

parsed_page = Nokogiri::HTML(unparsed_page)
sports = Array.new
	
sport_cards = parsed_page.css('.main-news__item')
sport_cards = sport_cards[0..1]
sport_cards.each do |sport_card|

	whes = sport_card.css('div.meta__date').text
	title = sport_card.css('.main-news__title').text
	img = sport_card.css('a img').attr('src').value
	link = sport_card.css('a').attr('href').value

		
	sport = {
	    :когда => whes,
		:название => title,
		:фото => img,
		:ссылка => link
	}
		
		sports << sport
end

Telegram::Bot::Client.run(token) do |bot|
    bot.listen do |message|
        case message
        when Telegram::Bot::Types::CallbackQuery
            case message.data
            when 'test'
                bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}\n#{foots.to_s.tr('"tn[','').tr('\\','').tr(",]","\n\n")}")
            when 'touch'
                bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}\n#{baskets.to_s.tr('"tn[','').tr('\\','').tr(",]","\n\n")}")
        	when 'news'
                bot.api.send_message(chat_id: message.from.id, text: "Hello, #{message.from.first_name}\n#{sports.to_s.tr('=>"',' ').tr("],}{[","\n")}")
            end
        when Telegram::Bot::Types::Message 
            case message.text
            when '/start'
                kb = [
                    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'футбол', callback_data: 'test'),
                    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'баскетбол', callback_data: 'touch'),
                    Telegram::Bot::Types::InlineKeyboardButton.new(text: 'новости', callback_data: 'news')
                ]
                markup = Telegram::Bot::Types::InlineKeyboardMarkup.new(inline_keyboard: kb)
                bot.api.send_message(chat_id: message.chat.id, text: 'Make a choice', reply_markup: markup)
            end
        end
    end
end


  		


  
 
  


