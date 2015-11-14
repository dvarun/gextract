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
  CSV.foreach(myfile.path) do |row|
   @keyword = Keyword.new
   @keyword.word = row.shift.strip
   @keyword.user_id = current_user.id
   @keyword.save
  end
  @words = Keyword.where(user_id: current_user.id)

  count = 0
  @all_links = []
  @top_adwords = []
  @top_adwords_url = []
  @right_adwords = []
  @right_adwords_url = []
  @all_non_adwords = []
  @all_non_adwords_url = []

  @words.each do |keyword|
   begin
    search_key = keyword.word.gsub! ' ','+'
    if search_key.nil?
     page = open "http://www.google.com/search?q=#{keyword.word}"
    else
     page = open "http://www.google.com/search?q=#{search_key}"
    end
    #page = open "http://www.google.com/search?q=hello"
    doc = Nokogiri::HTML page
    doc.xpath('//cite').each do |node| #all_links
     @all_links << node.text
    end

    @keyword_count = KeywordCount.new
    @keyword_count.keyword_id = keyword.id
    @keyword_count.user_id = current_user.id


    ########################top adwords####################################
    doc.xpath('//div[@id="tvcap"]/div[@id="tads"]//cite').each do |node| #top_adwords
     @top_adwords << node.text
    end
    @test = doc.search('//div[@id="tvcap"]//li[@class="ads-ad"]//cite').size
    doc.xpath('//div[@id="tvcap"]/div[@id="tads"]//cite').each do |node| #top_adwords_url
     @top_adwords_url << node.text
    end
    @keyword_count.top_count = @top_adwords.count
    ########################end top adwords####################################



    ########################right adwords####################################
    doc.xpath('//div[@id="rhs_block"]//li[@class="ads-ad"]/h3/a').each do |node| #right_adwords
     @right_adwords << node.text
    end
    doc.xpath('//div[@id="rhs_block"]//li[@class="ads-ad"]//cite').each do |node| #right_adwords_url
     @right_adwords_url << node.text
    end
    @keyword_count.right_count = @right_adwords.count
    ########################rnd right adwords####################################




    ########################total adwords####################################
    @total_adwords = @top_adwords.count +  @right_adwords.count
    @keyword_count.total_adword_count =  @total_adwords
    ########################end total adwords####################################



    ########################non adwords####################################
    doc.xpath('//div[@id="res"]//h3').each do |node| #all_non_adwords
     @all_non_adwords << node.text
    end
    @keyword_count.normal_count = @all_non_adwords.count

    doc.xpath('//div[@id="res"]//cite').each do |node| #all_non_adwords_url
     @all_non_adwords_url << node.text
    end
    ########################endnon adwords####################################



    ########################total adwords####################################
    @keyword_count.total_count =  @all_non_adwords.count + @total_adwords
    @keyword_count.save
    ########################end total adwords####################################


   rescue Errno::ECONNRESET => e
    count += 1
    retry unless count > 5
   end
  end

  #page = open "http://www.google.com/search?q=best+vps+Hosting"



  # @keyword_count = KeywordCount.new
  # @keyword_count.id = 1
  # @keyword_count.user_id = current_user.id
  # @keyword_count.top_count = @top_adwords.count
  # @keyword_count.right_count = @right_adwords.count
  # @keyword_count.total_adword_count =  @total_adwords
  # @keyword_count.normal_count = @all_non_adwords.count
  # @keyword_count.total_count =  @all_non_adwords.count + @total_adwords
  # @keyword_count.save



  # @search << doc.search('//div[@id="tvcap"]//li[@class="ads-ad"]/h3/a').to_s #top_adwords
  # @search << doc.search('//div[@id="tvcap"]//li[@class="ads-ad"]//cite').to_s #top_adwords_url
  #
  # @search << doc.search('//div[@id="rhs_block"]//li[@class="ads-ad"]/h3/a').to_s #right_adwords
  # @search << doc.search('//div[@id="rhs_block"]//li[@class="ads-ad"]//cite').to_s #right_adwords_url
  #
  # @search << doc.search('//li[@class="ads-ad"]/h3/a').to_s #all_adwords
  # @search << doc.search('//li[@class="ads-ad"]//cite').to_s #all_adwords_url
  #
  # @search << doc.search('//div[@id="res"]//h3').to_s #all_non_adwords
  # @search << doc.search('//div[@id="res"]//cite').to_s #all_non_adwords_url
  #
  # #@search << doc.search('//div[@id="res"]//cite').to_s #all_non_adwords_url
  # @search << doc.search('//cite').to_s #all_links
  #
  # @search << doc.search('//div[@id="resultStats"]/text()').to_s
  #
  # @search << doc.search('//*')

 end

end
