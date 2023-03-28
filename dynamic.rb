require 'selenium-webdriver'
require 'csv'

options = Selenium::WebDriver::Chrome::Options.new
options.headless!
driver = Selenium::WebDriver.for(:chrome, capabilities: [options])

driver.get 'http://quotes.toscrape.com/js/'

quotes = []
while true do
  quote_elements = driver.find_elements(css: '.quote')
  quote_elements.each do |quote_el|
    quote_text = quote_el.find_element(css: '.text').attribute('textContent')
    author = quote_el.find_element(css: '.author').attribute('textContent')
    quotes << [quote_text, author]
  end
  begin
    driver.find_element(css: '.next >a').click
  rescue
    break # Next button not found
  end
end

CSV.open(
  'quotes.csv',
  'w+',
  write_headers: true,
  headers: %w[Quote Author]
) do |csv|
  quotes.each do |quote|
    csv << quote
  end
end