class Admin::EventsController < Admin::AdminController
  # GET /admin_events
  # GET /admin_events.xml
  def index
    @events = Admin::Event.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /admin_events/1
  # GET /admin_events/1.xml
  def show
    @event = Admin::Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /admin_events/new
  # GET /admin_events/new.xml
  def new
    @event = Admin::Event.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /admin_events/1/edit
  def edit
    @event = Admin::Event.find(params[:id])
  end

  # POST /admin_events
  # POST /admin_events.xml
  def create
    @event = Admin::Event.new(params[:event])

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Admin::Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_events/1
  # PUT /admin_events/1.xml
  def update
    @event = Admin::Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:admin_event])
        flash[:notice] = 'Admin::Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_events/1
  # DELETE /admin_events/1.xml
  def destroy
    @event = Admin::Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(admin_events_url) }
      format.xml  { head :ok }
    end
  end
end
