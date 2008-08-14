class Admin::CompaniesController < ApplicationController
  
  before_filter :login_required, :admin_required

  def index
    @companies = Company.find(:all)

    respond_to do |format|
      format.html
    end
  end

  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @company }
    end
  end

  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  def create
    @company = Company.new(params[:company])

    respond_to do |format|
      if @company.save
        flash[:notice] = 'Company was successfully created.'
        format.html { redirect_to(admin_company_path(@company)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        flash[:notice] = 'Company was successfully updated.'
        format.html { redirect_to(admin_company_path(@company)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to(admin_companies_url) }
    end
  end
end
