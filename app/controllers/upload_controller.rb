require 'RMagick'
require 'exifr'

class UploadController < ApplicationController

  protect_from_forgery :only => [:index]
  before_filter :require_login, :except=>[:photo]

  private
  def require_login
    unless approved_photographer_logged_in?
      flash[:error] = "Ennek a funkciónak a használatához be kell lépned és jóváhagyott profillal kell rendelkezned!"
      redirect_to :not_authenticated
    end
  end

  public
  def index
    user = User.find session[:user_id]
    @events = Event.find_all_by_is_approved_and_event_type_id(true, user.photographer.event_types, :conditions => ["event_start <= ?", Date.today + 1 ]);
  end

  def photo

    logger.info "Uploading a file started."
    FileUtils.mkdir_p Rails.root.join('data',params[:event_id],params[:user_id])

    @user = User.find params[:user_id]
    logger.info "Uploading user: " + @user.email
    @photographer = @user.photographer
    logger.info "User is a photographer: " + @photographer.firstname
    @event = Event.find params[:event_id]
    logger.info "Selected event is " + @event.title

    unless params[:upfile] == nil
      upfile = params[:upfile]
      @photo = Photo.new
      @photo.filename = upfile.original_filename
      @photo.fingerprint = Digest::MD5.hexdigest( upfile.original_filename + Time.now.to_s )
      @photo.photographer_id = @photographer
      @photo.event = @event
      @photo.path = "photos/"+params[:event_id]
      
      if ( @photo.save )
        File.open(Rails.root.join('data',params[:event_id],params[:user_id], @photo.fingerprint ), 'w') do |file|
          file.write(upfile.read)
        end

        #read exif info
        photo_exif = EXIFR::JPEG.new(File.join(RAILS_ROOT,'data',params[:event_id],params[:user_id],@photo.fingerprint))
        if photo_exif.exif? == true
          logger.info photo_exif.model
          logger.info photo_exif.date_time
          logger.info photo_exif.exposure_time.to_s
          logger.info photo_exif.f_number.to_f
          logger.info photo_exif.gps
#          logger.info photo_exif.gps.latitude
#          logger.info photo_exif.gps.longitude

          exif = Exif.new
          exif.date_time = photo_exif.date_time
          exif.exposure_time = photo_exif.exposure_time.to_s
          exif.f_number = photo_exif.f_number.to_f
          exif.height = photo_exif.height.to_s
          exif.model = photo_exif.model
          exif.width = photo_exif.width
          if ( exif.save )
            @photo.exif = exif

            price = Integer(params[:price])

            if price == -1
              @photo.price = exif.autoprice
            else
              @photo.price = price
            end

            @photo.save
          end
        end


        FileUtils.mkdir_p Rails.root.join('public','images','photos',params[:event_id])

        i_thumb = Magick::Image.read(Rails.root.join('data',params[:event_id],params[:user_id], @photo.fingerprint )).first
        i_thumb.resize_to_fit!(320,200)
        i_thumb.write(File.join(RAILS_ROOT,'public','images','photos',params[:event_id], @photo.fingerprint+".jpg"))
          
        i_thumb = Magick::Image.read(Rails.root.join('data',params[:event_id],params[:user_id], @photo.fingerprint )).first
        i_thumb.resize_to_fit!(800,600)
        i_thumb.write(File.join(RAILS_ROOT,'public','images','photos',params[:event_id], "800_"+@photo.fingerprint+".jpg"))

        #        File.open(Rails.root.join('data',params[:event_id],params[:user_id], @photo.fingerprint ), 'r') do |file|
        #          i_original = Magick::Image.from_blob(file.read)
        #          i_thumb = i_original.first.change_geometry!("#{320}x#{200}") { |cols, rows, img|
        #            if cols < 320 || rows < 200
        #              img.resize!(cols, rows)
        #              bg = Magick::Image.new(320,200) {self.background_color = "white"}
        #              bg.composite(img, Magick::CenterGravity, Magick::OverCompositeOp)
        #            else
        #              img.resize!(320,200)
        #            end
        #          }
        #        end

      end
    end
    render :text => "1"

    logger.info "Uploading a file ended."
  end

end
