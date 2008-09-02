class CompanyPerson < ActiveRecord::Base
  include ActivityLogger
  
  belongs_to :company
  belongs_to :person
  
  has_many :activities, :foreign_key => "item_id", :dependent => :destroy
  
  after_save :log_activity
  
  private
  
    def log_activity
      activity = Activity.create!(:item => self, :person => self.person)
      add_activities(:activity => activity, :person => person)
    end
end
