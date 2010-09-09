class PhotosController < ApplicationController

  before_filter :require_admin, :except => [ :index, :random, :show ]
  layout "general", :except => [:random]

  def index
    if  params[:photographer_id]
      index_photos
    end
    if  params[:event_id]
      index_events
    end

  end

  def index_photos
    @photos = Photo.find_all_by_photographer_id params[:photographer_id]

    respond_to do |format| 
      format.html {
        render "index_photos.html.erb", :layout => false
      }
      format.xml {
        render :xml => @photos
      }
    end
  end

  def index_events

    respond_to do |format|
      format.html {
        if params[:page]
          page = Integer(params[:page])
        else
          page = 1
        end
        page = 1 if page <= 0

        if params[:search] and params[:search].length > 0
          photo_count = Photo.count_by_sql "SELECT COUNT(id) FROM photos WHERE is_approved=1 and event_id=#{params[:event_id]} AND startnumber LIKE UPPER(TRIM('%#{params[:search]}%'))"
        else
          photo_count = Photo.count_by_sql "SELECT COUNT(id) FROM photos WHERE is_approved=1 and event_id=#{params[:event_id]}"
        end
        
        @max_page = (photo_count / 12.0).ceil
        @max_page = 1 if @max_page <= 0

        page = @max_page if page > @max_page
        @current_page = page

        if ( session[:cart] != nil )
            exclude = session[:cart].count>0?session[:cart]:0;
        else
            exclude = 0;
        end

        if params[:search] and params[:search].length > 0 
          @photos = Photo.find_all_by_event_id_and_is_approved params[:event_id], true, :offset => (page-1)*10, :limit => 12, :conditions=>["id not in (?) AND startnumber LIKE UPPER(TRIM(?))", exclude, "%#{params[:search]}%" ]
        else
          @photos = Photo.find_all_by_event_id_and_is_approved params[:event_id], true, :offset => (page-1)*12, :limit => 12, :conditions=>["id not in (?)", exclude]
        end

        @event = Event.find params[:event_id]
        #index.html.erb
        
        render "index_events.html.erb"

      }
      format.xml {
        @photos = Photo.find_all_by_event_id params[:event_id]
        render :xml => @photos
      }
    end
  end

  def random
    @photo = Photo.find :first, :conditions=>["is_approved=1"], :order=>"rand()"
  end

  def show
    @photo = Photo.find params[:id]
  end

  def download
    @photo = Photo.find params[:id]
    from_cart = false
    unless params[:carthash] == nil
      cart = Cart.find_last_by_carthash params[:carthash]
      unless cart == nil
        if  cart.is_paid
          from_cart = true
        end
      end
    end
    
    if (from_cart or @photo.price == 0)
      send_file File.join(RAILS_ROOT,'data',@photo.event_id.to_s,@photo.photographer.user_id.to_s,@photo.fingerprint), :type=>"image/jpeg"
    end
  end

end