class User < ActiveRecord::Base
    has_many :memes

    # devise :database_authenticatable, :registerable,
    #      :recoverable, :rememberable, :validatable

    validates_presence_of :email, :password
    validates_uniqueness_of :email
    has_secure_password
end