class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.text :content, null: false
      t.references :user, null: false, foreign_key: true
      t.integer :likes_count, default: 0, null: false
      t.integer :comments_count, default: 0, null: false

      t.timestamps null: false
    end

    add_index :tweets, :created_at
  end
end
