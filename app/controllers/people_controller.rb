class PeopleController < ApplicationController
  
  skip_before_filter :require_activation, :only => :verify_email
  skip_before_filter :admin_warning, :only => [ :show, :update ]
  before_filter :login_required, :only => [ :show, :edit, :update ]
  before_filter :correct_user_required, :only => [ :edit, :update ]
  before_filter :setup
  
  def index
    @people = Person.mostly_active(params[:page])

    respond_to do |format|
      format.html
    end
  end
  
  def show
    @person = Person.find(params[:id])
    unless @person.active? or current_person.admin?
      flash[:error] = "That person is not active"
      redirect_to home_url and return
    end
    if logged_in?
      @some_contacts = @person.some_contacts
    end
    respond_to do |format|
      format.html
    end
  end
  
  def new
    @body = "register single-col"
    @person = Person.new

    respond_to do |format|
      format.html
    end
  end

  def create
    cookies.delete :auth_token
    @person = Person.new(params[:person])
    respond_to do |format|
      @person.email_verified = false if global_prefs.email_verifications?
      @person.save
      if @person.errors.empty?
        if global_prefs.email_verifications?
          @person.email_verifications.create
          flash[:notice] = %(Thanks for signing up! Check your email
                             to activate your account.)
          format.html { redirect_to(home_url) }
        else
          self.current_person = @person
          flash[:notice] = "Thanks for signing up!"
          format.html { redirect_back_or_default(home_url) }
        end
      else
        @body = "register single-col"
        format.html { render :action => 'new' }
      end
    end
  rescue ActiveRecord::StatementInvalid
    # Handle duplicate email addresses gracefully by redirecting.
    redirect_to home_url
  end

  def verify_email
    verification = EmailVerification.find_by_code(params[:id])
    if verification.nil?
      flash[:error] = "Invalid email verification code"
      redirect_to home_url
    else
      cookies.delete :auth_token
      person = verification.person
      person.email_verified = true; person.save!
      self.current_person = person
      flash[:success] = "Email verified. Your profile is active!"
      redirect_to person
    end
  end

  def edit
    @person = Person.find(params[:id])

    respond_to do |format|
      format.html
    end
  end

  def update
    @person = Person.find(params[:id])
    respond_to do |format|
      case params[:type]
      when 'info_edit'
        if !preview? and @person.update_attributes(params[:person])
          flash[:success] = 'Profile updated!'
          format.html { redirect_to(@person) }
        else
          if preview?
            @preview = @person.description = params[:person][:description]
          end
          format.html { render :action => "edit" }
        end
      when 'password_edit'
        if global_prefs.demo?
          flash[:error] = "Passwords can't be changed in demo mode."
          redirect_to @person and return
        end
        if @person.change_password?(params[:person])
          flash[:success] = 'Password changed.'
          format.html { redirect_to(@person) }
        else
          format.html { render :action => "edit" }
        end
      end
    end
  end
  
  def common_contacts
    @person = Person.find(params[:id])
    @common_contacts = @person.common_contacts_with(current_person,
                                                          params[:page])
    respond_to do |format|
      format.html
    end
  end
  
  def add_company
    @person = Person.find(params[:id])
    company_id = params[:company][:id].empty? ? 0 : params[:company][:id]
    (Preference.find(:first).node_number-1).times do |num|
      company_id = params["company#{num}"][:id] unless params["company#{num}"].nil?
    end
    respond_to do |format|
      if company_id != 0 and !@person.company_ids.include?(company_id.to_i)
        if @person.companies.length < Preference.find(:first).number_of_companies
          @person.companies << Company.find(company_id) unless @person.company_ids.include?(company_id.to_i)
          flash[:success] = 'Company added.'
          format.html { redirect_to(edit_person_path(@person)+"?edit=company") }
        else
          flash[:error] = 'You can\'t add more companies.'
          format.html { redirect_to(edit_person_path(@person)+"?edit=company") }
        end
      else
        format.html { redirect_to(edit_person_path(@person)+"?edit=company") }
      end
    end
  end
  
  def delete_company
    @person = Person.find(params[:id])
    @person.companies.delete(Company.find(params[:company_id]))
    respond_to do |format|
      flash[:success] = 'Company deleted'
      format.html { redirect_to(edit_person_path(@person)+"?edit=company") }
    end
  end
  
  private

    def setup
      @body = "person"
    end
  
    def correct_user_required
      redirect_to home_url unless Person.find(params[:id]) == current_person
    end
    
    def preview?
      params["commit"] == "Preview"
    end
end
