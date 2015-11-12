class CreateKeywordCounts < ActiveRecord::Migration
 def change
  create_table :keyword_counts do |t|
   t.integer :user_id
   t.integer :keyword_id
   t.integer :top_count
   t.integer :right_count
   t.integer :total_adword_count
   t.integer :normal_count
   t.integer :total_count
   t.integer :total_result
   t.timestamps null: false
  end
 end
end
