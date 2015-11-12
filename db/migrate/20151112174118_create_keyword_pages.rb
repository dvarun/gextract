class CreateKeywordPages < ActiveRecord::Migration
  def change
    create_table :keyword_pages do |t|
      t.integer :user_id
      t.integer :keyword_id
      t.binary :page

      t.timestamps null: false
    end
  end
end
