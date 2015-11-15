class KeywordsController < ApplicationController
 require 'csv'
 require 'rubygems'
 require 'nokogiri'
 require 'open-uri'
 before_filter :authenticate_user!
 def index
  @keyword = Keyword.where(user_id: current_user.id)
 end

 def new
  @keyword = Keyword.new
 end

 def create
  myfile = params[:file]

  begin
   CSV.foreach(myfile.path) do |row|
    @keyword = Keyword.new
    @keyword.word = row.shift.strip
    @keyword.user_id = current_user.id
    @keyword.save
   end
  rescue
   redirect_to new_keyword_path, notice: "please select file before submitting!"
  end

  @words = Keyword.where(user_id: current_user.id)

  count = 0
  @words.each do |keyword|
   begin

    @all_links = []
    @top_adwords = []
    @top_adwords_url = []
    @right_adwords = []
    @right_adwords_url = []
    @all_non_adwords = []
    @all_non_adwords_url = []

    search_key = keyword.word.gsub! ' ','+'
    if search_key.nil?
     page = open "https://www.google.com/search?q=#{keyword.word}"
    else
     page = open "https://www.google.com/search?q=#{search_key}"
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
    doc.xpath('//div[@id="tvcap"]//li[@class="ads-ad"]//cite').each do |node| #top_adwords
     @keyword_result = KeywordResult.new
     @keyword_result.user_id = current_user.id
     @keyword_result.keyword_id = keyword.id
     @keyword_result.top_url = node.text
     @keyword_result.save
     @top_adwords << node.text
    end
    @keyword_count.top_count = @top_adwords.count
    ########################end top adwords####################################



    ########################right adwords####################################
    doc.xpath('//div[@id="rhs_block"]//li[@class="ads-ad"]//cite').each do |node| #right_adwords
     @keyword_result = KeywordResult.new
     @keyword_result.user_id = current_user.id
     @keyword_result.keyword_id = keyword.id
     @keyword_result.right_url = node.text
     @keyword_result.save
     @right_adwords << node.text
    end
    @keyword_count.right_count = @right_adwords.count
    ########################end right adwords####################################




    ########################total adwords####################################
    @total_adwords = @top_adwords.count +  @right_adwords.count
    @keyword_count.total_adword_count =  @total_adwords
    ########################end total adwords####################################



    ########################non adwords####################################
    doc.xpath('//div[@id="res"]//cite').each do |node| #all_non_adwords
     @keyword_result = KeywordResult.new
     @keyword_result.user_id = current_user.id
     @keyword_result.keyword_id = keyword.id
     @keyword_result.normal_url = node.text
     @keyword_result.save
     @all_non_adwords << node.text
    end
    @keyword_count.normal_count = @all_non_adwords.count
    ########################endnon adwords####################################


    ########################total adwords####################################
    @keyword_count.total_count =  @all_non_adwords.count + @total_adwords
    @keyword_count.total_result = doc.search('//div[@id="resultStats"]/text()').to_s
    @keyword_count.save
    ########################end total adwords####################################


    @keyword_page = KeywordPage.new
    @keyword_page.user_id = current_user.id
    @keyword_page.keyword_id = keyword.id
    @keyword_page.page = doc.search('//*').to_s
    @keyword_page.save

   rescue Errno::ECONNRESET => e
    count += 1
    retry unless count > 5
   end
  end

 end

 def show
  @keyword = current_user.keywords.find(params[:id])
 end

end
