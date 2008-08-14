module CompaniesHelper
  def companies
    Company.find(:all, :order => "name ASC")
  end
end
