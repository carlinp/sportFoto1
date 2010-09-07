class UsersController < ApplicationController

  before_filter :require_admin, :except => [ :new, :create, :login, :logout ]

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def login
    @user = User.new(params[:loginform])
    valid_user = User.find(:first,:conditions => ["email=? and password=?", @user.email, @user.password])
    
    if valid_user
      session[:user_id] = valid_user.id
      if (valid_user.photographer != nil and valid_user.photographer.get_profile_completion_status < 30)
        flash[:notice] = "A profilod 50% alatti. Kérünk, pótold a hiányzó adatokat! Ezt megteheted az <strong>Adatok</strong> menü <strong>Személyes</strong> fülén."
        redirect_to valid_user.photographer
      else
        redirect_to :controller=>'events',:action => 'index'
      end
    else
      redirect_to :controller=>'photographers', :action => 'index'
    end
  end

  def logout
    if session[:user_id]
      reset_session
      redirect_to :controller=>'events', :action => 'index'
    end
  end

end
