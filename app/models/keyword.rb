class Keyword < ActiveRecord::Base
 has_many  :keyword_counts
 has_many :keyword_results
 end
