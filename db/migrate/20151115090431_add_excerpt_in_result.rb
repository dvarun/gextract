class AddExcerptInResult < ActiveRecord::Migration
  def change
   add_column :keyword_results,:excerpt,:string
  end
end
