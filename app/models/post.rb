class Post < ActiveRecord::Base
  has_many :comments
  belongs_to :user
  acts_as_voteable
end
