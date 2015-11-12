class CreateKeywordResults < ActiveRecord::Migration
 def change
  create_table :keyword_results do |t|
   t.integer :user_id
   t.integer :keyword_id
   t.string :top_url
   t.string :right_url
   t.string :normal_url
   t.timestamps null: false
  end
 end
end
