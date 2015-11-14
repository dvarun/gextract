class Keyword < ActiveRecord::Base
 has_one :keyword_count
 has_many :keyword_results
 has_many :keyword_pages
 end
