class Meme < ActiveRecord::Base 
    belongs_to :user
    validates_presence_of :url, :title, :date_published
end