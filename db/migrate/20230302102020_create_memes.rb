class CreateMemes < ActiveRecord::Migration[6.1]
  def change
    create_table :memes do |t|
      t.string :title, null: false
      t.text :description
      t.string :url, null: false
      t.references :user, null: false
      t.datetime :due
      t.datetime :createdAt, null: false
      t.integer :status, null: false, default: 0

      
    end
  end
end
