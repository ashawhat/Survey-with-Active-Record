class Survey < ActiveRecord::Base
  has_many :questions
  validates :name, :presence => true, :length => { :maximum => 47 }
end
