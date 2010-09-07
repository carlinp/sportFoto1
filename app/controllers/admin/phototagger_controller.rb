class Admin::PhototaggerController < Admin::AdminController

  protect_from_forgery :except => [:tag]

  
  def tag

    unless params[:id] == nil
      photo = Admin::Photo.find params[:id]
      startnumber=params[:startnumber]
      photo.startnumber = startnumber
      if startnumber.length > 0
        photo.has_startnumber = 1
      end
      unless params[:approve] == nil
        approved=1
      else
        approved=0
      end
      photo.is_approved = approved
      photo.is_processed = 1
      photo.save
    end

    @photo = Admin::Photo.find :first, :conditions=>["is_approved=? and is_processed=? and is_processing=?", false, false, false]
    

  end

  def show
    @photo = Admin::Photo.find params[:id]
    send_file File.join(RAILS_ROOT,'data',@photo.event_id.to_s,@photo.photographer.user_id.to_s,@photo.fingerprint), :type=>"image/jpeg"
  end

  def show_midsize
    @photo = Admin::Photo.find params[:id]

    FileUtils.mkdir_p Rails.root.join('data','temp','photos',@photo.event_id.to_s)

    i_thumb = Magick::Image.read(Rails.root.join('data',@photo.event_id.to_s,@photo.photographer.user_id.to_s, @photo.fingerprint )).first
    i_thumb.resize_to_fit!(1024,768)
    mid_filename = File.join(RAILS_ROOT,'data','temp','photos',@photo.event_id.to_s, @photo.fingerprint+".jpg")
    i_thumb.write(mid_filename)

    send_file mid_filename, :type=>"image/jpeg"
  end

end
