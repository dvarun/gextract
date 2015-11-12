class KeywordsController < ApplicationController
 require 'csv'
 require 'rubygems'
 require 'nokogiri'
 require 'open-uri'
 before_filter :authenticate_user!
 def index

 end

 def new
  @keyword = Keyword.new
 end

 def create
  myfile = params[:file]
  @words = []
  CSV.foreach(myfile.path) do |row|
   @words << row.shift.strip
  end

  @keyword = Keyword.new
  @keyword.word = @words
  @keyword.user_id = current_user.id
  @keyword.save


  page = open "http://www.google.com/search?q=best+vps+hosting"
  doc = Nokogiri::HTML page
  @search = []
  # doc.xpath('//li[@class="ads-ad"]/h3').each do |node|
  #  @search << node.text
  # end
  @search << doc.search('//div[@id="tvcap"]//li[@class="ads-ad"]/h3/a').to_s #top_adwords
  @search << doc.search('//div[@id="tvcap"]//li[@class="ads-ad"]//cite').to_s #top_adwords_url

  @search << doc.search('//div[@id="rhs_block"]//li[@class="ads-ad"]/h3/a').to_s #right_adwords
  @search << doc.search('//div[@id="rhs_block"]//li[@class="ads-ad"]//cite').to_s #right_adwords

  @search << doc.search('//li[@class="ads-ad"]/h3/a').to_s #all_adwords
  @search << doc.search('//li[@class="ads-ad"]//cite').to_s #all_adwords_url

  @search << doc.search('//div[@id="res"]//h3').to_s #all_non_adwords
  @search << doc.search('//div[@id="res"]//cite').to_s #all_non_adwords_url

  #@search << doc.search('//div[@id="res"]//h3/a/@href').to_s #all_non_adwords_url
  @search << doc.search('//cite').to_s #all_links

  @search << doc.search('//div[@id="resultStats"]/text()').to_s #total_result_stats

  @search << doc.search('//*')

 end

end
