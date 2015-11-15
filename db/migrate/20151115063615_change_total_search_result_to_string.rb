class ChangeTotalSearchResultToString < ActiveRecord::Migration
  def change
   change_column :keyword_counts, :total_result, :string
  end
end
