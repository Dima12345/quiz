require 'mechanize'
require 'nokogiri'

class Quiz
  def run
    html_page = open_page
    headers = html_page.css('thead').css('th').to_a
    values = html_page.css('tbody').css('tr')
    answer = Hash.new
    values.each do |tr|
      key = String.new
      value = Hash.new
      tr.css('td').to_a.each_index do |index|
        if index == 0
          key = tr.css('td')[index].text
        else
          value.merge!({ headers[index].text.downcase.to_sym => tr.css('td')[index].text })
        end
        answer.merge!({ key => value })
      end
    end
    answer
  end

  private

  def open_page
    agent = Mechanize.new
    page = agent.get('https://staqresults.herokuapp.com')
    form = page.form
    form.email = 'test@example.com'
    form.password = 'secret'
    page = agent.submit(form)
    html_page = Nokogiri::HTML(page.content)
  end
end
