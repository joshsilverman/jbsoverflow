class Post < ActiveRecord::Base
  has_many :comments
  has_many :users, :through => :sponsorships, :uniq => true
  has_many :sponsorships
  acts_as_voteable
end
