class Admin::PhotographersController < Admin::AdminController
  # GET /admin_photographers
  # GET /admin_photographers.xml
  def index
    @photographers = Admin::Photographer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photographers }
    end
  end

  # GET /admin_photographers/1
  # GET /admin_photographers/1.xml
  def show
    @photographer = Admin::Photographer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photographer }
    end
  end

  # GET /admin_photographers/new
  # GET /admin_photographers/new.xml
  def new
    @photographer = Admin::Photographer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photographer }
    end
  end

  # GET /admin_photographers/1/edit
  def edit
    @photographer = Admin::Photographer.find(params[:id])
  end

  # POST /admin_photographers
  # POST /admin_photographers.xml
  def create
    @photographer = Admin::Photographer.new(params[:photographer])

    respond_to do |format|
      if @photographer.save
        flash[:notice] = 'Admin::Photographer was successfully created.'
        format.html { redirect_to(@photographer) }
        format.xml  { render :xml => @photographer, :status => :created, :location => @photographer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photographer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_photographers/1
  # PUT /admin_photographers/1.xml
  def update
    @photographer = Admin::Photographer.find(params[:id])

    respond_to do |format|
      if @photographer.update_attributes(params[:photographer])
        flash[:notice] = 'Admin::Photographer was successfully updated.'
        format.html { redirect_to(@photographer) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @photographer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_photographers/1
  # DELETE /admin_photographers/1.xml
  def destroy
    @photographer = Admin::Photographer.find(params[:id])
    @photographer.destroy

    respond_to do |format|
      format.html { redirect_to(admin_photographers_url) }
      format.xml  { head :ok }
    end
  end
end
