class KeywordsController < ApplicationController
 require 'csv'
 require 'rubygems'
 require 'nokogiri'
 require 'open-uri'
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
  @key = Keyword.first



  page = open "http://www.google.com/search?num=100&q=stackoverflow"
  html = Nokogiri::HTML page
  @search = []
  html.search("cite").each do |cite|
   @search << cite.inner_text
  end

 end

end
