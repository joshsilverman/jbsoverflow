class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  acts_as_voteable
end
