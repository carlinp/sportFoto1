class User < ActiveRecord::Base
  has_one :photographer

  validates_presence_of :email, :password

  validates_uniqueness_of :email, :case_sensitive => false 
  
end
