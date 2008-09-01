class Company < ActiveRecord::Base
  acts_as_tree :order=>"name"
  has_many :company_persons
end
