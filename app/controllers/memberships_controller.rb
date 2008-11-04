class MembershipsController < ApplicationController
  
  def create
    @group = Group.find(params[:group_id])

    respond_to do |format|
      if Membership.request(current_person, @group)
        if @group.public?
          flash[:notice] = "You have joined to '#{@group.name}'"
        else
          flash[:notice] = 'Membership request sent!'
        end
        format.html { redirect_to(home_url) }
      else
        # This should only happen when people do something funky
        # like trying to join a group that has a request pending
        flash[:notice] = "Invalid membership"
        format.html { redirect_to(home_url) }
      end
    end
  end
  
  def destroy
    @membership = Membership.find(params[:id])
    @membership.breakup
    
    respond_to do |format|
      flash[:success] = "You have left the group #{@membership.group.name}"
      format.html { redirect_to( person_url(current_person)) }
    end
  end
  
  def unsuscribe
    @membership = Membership.find(params[:id])
    @membership.breakup
    
    respond_to do |format|
      flash[:success] = "You have unsuscribe '#{@membership.person.name}' from group '#{@membership.group.name}'"
      format.html { redirect_to(members_group_path(@membership.group)) }
    end
  end
  
  def suscribe
    @membership = Membership.find(params[:id])
    @membership.accept

    respond_to do |format|
      flash[:success] = "You have accept '#{@membership.person.name}' for group '#{@membership.group.name}'"
      format.html { redirect_to(members_group_path(@membership.group)) }
    end
  end
  
  
  
#  # GET /memberships
#  # GET /memberships.xml
#  def index
#    @memberships = Membership.find(:all)
#
#    respond_to do |format|
#      format.html # index.html.erb
#      format.xml  { render :xml => @memberships }
#    end
#  end
#
#  # GET /memberships/1
#  # GET /memberships/1.xml
#  def show
#    @membership = Membership.find(params[:id])
#
#    respond_to do |format|
#      format.html # show.html.erb
#      format.xml  { render :xml => @membership }
#    end
#  end
#
#  # GET /memberships/new
#  # GET /memberships/new.xml
#  def new
#    @membership = Membership.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @membership }
#    end
#  end
#
#  # GET /memberships/1/edit
#  def edit
#    @membership = Membership.find(params[:id])
#  end
#
#  # POST /memberships
#  # POST /memberships.xml
#  def create
#    @membership = Membership.new(params[:membership])
#
#    respond_to do |format|
#      if @membership.save
#        flash[:notice] = 'Membership was successfully created.'
#        format.html { redirect_to(@membership) }
#        format.xml  { render :xml => @membership, :status => :created, :location => @membership }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @membership.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # PUT /memberships/1
#  # PUT /memberships/1.xml
#  def update
#    @membership = Membership.find(params[:id])
#
#    respond_to do |format|
#      if @membership.update_attributes(params[:membership])
#        flash[:notice] = 'Membership was successfully updated.'
#        format.html { redirect_to(@membership) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @membership.errors, :status => :unprocessable_entity }
#      end
#    end
#  end
#
#  # DELETE /memberships/1
#  # DELETE /memberships/1.xml
#  def destroy
#    @membership = Membership.find(params[:id])
#    @membership.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(memberships_url) }
#      format.xml  { head :ok }
#    end
#  end
end
