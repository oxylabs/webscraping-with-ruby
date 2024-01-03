require 'httparty'
require 'nokogiri'
require 'csv'

CSV.open(
  'games.csv',
  'w+',
  write_headers: true,
  headers: %w[Title, Price, Categories]
) do |csv|
  50.times do |i|
    response = HTTParty.get("https://sandbox.oxylabs.io/products?page={i+1}")
    document = Nokogiri::HTML4(response.body)
    all_game_containers = document.css('.product-card')
    all_games_containers.each do |container|
      title = container.css('h4').text.strip
      price = container.css('.price-wrapper').text.delete('^0-9.')
      category_elements = container.css('.category span')
      categories = category_elements.map { |elem| elem.text.strip }.join(', ')    
      game = [title, price, categories]
      csv << game
    end
  end
end
