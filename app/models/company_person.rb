class CompanyPerson < ActiveRecord::Base
  belongs_to :company
  belongs_to :person
end
