class CreateKeywords < ActiveRecord::Migration
 def change
  create_table :keywords do |t|
   t.integer :user_id
   t.string :word
   t.timestamps null: false
  end
 end
end
