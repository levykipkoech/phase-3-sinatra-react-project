class Meme < ActiveRecord::Base 
    belongs_to :user
    validates_presence_of :url, :title, :date_published
    validates :title, presence: true
    validates :url, presence: true
    validates :description, presence: true
end