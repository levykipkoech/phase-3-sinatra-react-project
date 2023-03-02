class User < ActiveRecord::Base
    has_many :memes
    validates_presence_of :email, :password
    validates_uniqueness_of :email
    has_secure_password
end