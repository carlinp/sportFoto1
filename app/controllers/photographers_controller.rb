class PhotographersController < ApplicationController

  before_filter :require_auth, :only => [:edit, :update]
  before_filter :require_admin, :only => [:destroy]

  private
  def require_auth
    pid = Integer(params[:id])
    sid = Integer(session[:user_id])
    unless pid == sid
      flash[:error] = "Nincs jogosultságod."
      redirect_to :not_authenticated
    end
  end

  public
  # GET /photographers
  # GET /photographers.xml
  def index
    @photographers = Photographer.find_all_by_is_public_and_is_approved_and_is_active(true, true, true)
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photographers }
    end
  end

  # GET /photographers/1
  # GET /photographers/1.xml
  def show
    @photographer = Photographer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photographer }
    end
  end

  # GET /photographers/new
  # GET /photographers/new.xml
  def new
    @photographer = Photographer.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photographer }
    end
  end

  # GET /photographers/1/edit
  def edit
    @photographer = Photographer.find(params[:id])
    @sold_num = 0
    @sold_value = 0
    @paid_num = 0
    @paid_value = 0
    @photographer.photos.each do |photo|
      @sold_num += photo.sold_num
      @sold_value += photo.sold_price_total
      @paid_value += photo.paid_price_total
    end
  end

  # POST /photographers
  # POST /photographers.xml
  def create
    @photographer = params[:photographer]
    @user = User.new(@photographer[:user])
    @photographer[:user] = @user

    @photographer = Photographer.new(params[:photographer])

    respond_to do |format|
      if @photographer.save
        flash[:notice] = 'Létrehoztuk a profilodat. Mostmár bejelentkezhetsz a Fotósoknak menüpontban.'
        format.html { redirect_to(@photographer) }
        format.xml  { render :xml => @photographer, :status => :created, :location => @photographer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photographer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photographers/1
  # PUT /photographers/1.xml
  def update
    @photographer = Photographer.find(params[:id])

    unless params[:photographer][:avatar] == nil
        uploaded = params[:photographer][:avatar]
        params[:photographer][:avatar] = params[:id]+'_'+uploaded.original_filename
        File.open(Rails.root.join('public','uploads', params[:id]+'_'+uploaded.original_filename), 'w') do |file|
          file.write(uploaded.read)
        end
    end

    respond_to do |format|
      if @photographer.update_attributes(params[:photographer])
        
        @photographer.photographers_event_types.destroy_all
        unless params[:photographer_event_type] == nil
          params[:photographer_event_type].each do |key,value|
            pet = PhotographersEventType.new
            pet.event_type_id = value
            pet.photographer_id = @photographer.id
            pet.save!
          end
        end

        flash[:notice] = 'Adataidat elmentettük.'
        format.html { redirect_to(@photographer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photographer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photographers/1
  # DELETE /photographers/1.xml
  def destroy
    @photographer = Photographer.find(params[:id])
    @photographer.destroy

    respond_to do |format|
      format.html { redirect_to(photographers_url) }
      format.xml  { head :ok }
    end
  end
end
