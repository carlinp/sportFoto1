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

        if params[:spot_title] and params[:spot_title].length >0 and params[:from_time] and params[:to_time]
          photo_count = Photo.count :joins=>"LEFT OUTER JOIN exifs on photos.exif_id=exifs.id LEFT OUTER JOIN spots ON photos.spot_id=spots.id",
                                    :conditions => ["is_approved=1 and photos.event_id=? AND spots.name=? AND exifs.date_time BETWEEN FROM_UNIXTIME(?)-INTERVAL 2 HOUR AND FROM_UNIXTIME(?)-INTERVAL 2 HOUR" ,params[:event_id], params[:spot_title], params[:from_time][0,10].to_i, params[:to_time][0,10].to_i ]
                                    
        elsif params[:search] and params[:search].length > 0
          photo_count = Photo.count_by_sql "SELECT COUNT(id) FROM photos WHERE is_approved=1 and event_id=#{params[:event_id]} AND startnumber RLIKE UPPER(TRIM('[[:<:]]#{params[:search]}[[:>:]]'))"
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

        if params[:spot_title] and params[:spot_title].length >0 and params[:from_time] and params[:to_time]
          @photos = Photo.find_all_by_event_id_and_is_approved params[:event_id], true,
                                    :joins=>"LEFT OUTER JOIN exifs on photos.exif_id=exifs.id LEFT OUTER JOIN spots ON photos.spot_id=spots.id",
                                    :conditions => ["spots.name=? AND exifs.date_time BETWEEN FROM_UNIXTIME(?)-INTERVAL 2 HOUR AND FROM_UNIXTIME(?)-INTERVAL 2 HOUR" , params[:spot_title], params[:from_time][0,10].to_i, params[:to_time][0,10].to_i ],
                                    :order => "exifs.date_time ASC",
                                    :offset => (page-1)*10, :limit => 12
        elsif params[:search] and params[:search].length > 0
          @photos = Photo.find_all_by_event_id_and_is_approved params[:event_id], true, :offset => (page-1)*10, :limit => 12, 
                    :conditions=>["photos.id not in (?) AND startnumber RLIKE UPPER(TRIM(?))", exclude, "[[:<:]]#{params[:search]}[[:>:]]" ],
                    :joins => "LEFT OUTER JOIN exifs ON photos.exif_id=exifs.id",
                    :order => "exifs.date_time ASC"
        else
          @photos = Photo.find_all_by_event_id_and_is_approved params[:event_id], true, :offset => (page-1)*12, :limit => 12, 
                    :conditions=>["photos.id not in (?)", exclude],
                    :joins => "LEFT OUTER JOIN exifs ON photos.exif_id=exifs.id",
                    :order => "exifs.date_time ASC"
        end

        @event = Event.find params[:event_id]

        min_photo_time = Photo.minimum "date_time",
                    :conditions => ["is_approved=1 AND event_id=?", @event.id],
                    :joins => "LEFT OUTER JOIN exifs ON photos.exif_id=exifs.id"

        if ( min_photo_time != nil)
          @min_time = DateTime.parse min_photo_time

          @max_time = DateTime.parse Photo.maximum "date_time",
                      :conditions => ["is_approved=1 AND event_id=?", @event.id],
                      :joins => "LEFT OUTER JOIN exifs ON photos.exif_id=exifs.id"
        else
          @min_time = @event.event_start
          @max_time = @event.event_end
        end

        if params[:from_time] and params[:from_time].length >0
          @from_time = params[:from_time].to_i
        else
          @from_time = 0
        end
        if params[:to_time] and params[:to_time].length >0
          @to_time = params[:to_time].to_i
        else
          @to_time = 0
        end
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