class Photographer < ActiveRecord::Base
  belongs_to :user
  has_many :photographers_event_types
  has_many :photos
  has_many :event_types, :through => :photographers_event_types
  accepts_nested_attributes_for :event_types, :allow_destroy => true

  validates_associated :user, :message => "Gond van az email cím és jelszó mezőkkel!"

  def count_approved_pictures
    photo_count = Photo.count_by_sql "SELECT COUNT(id) FROM photos WHERE is_approved=1 and photographer_id=#{id}"
    return photo_count
  end

  def count_tagged_pictures
    photo_count = Photo.count_by_sql "SELECT COUNT(id) FROM photos WHERE has_startnumber=1 and photographer_id=#{id}"
    return photo_count
  end

  def has_event_type(id)
    event_types.each do |event_type|
      if id == event_type.id
        return true
      end
    end
    return false
  end

  def get_profile_completion_status
    percent = 0
    if photographers_event_types.size > 0
      percent += 10
    end

    if firstname.size > 0 and lastname.size > 0 and contact.size > 0
      percent += 20
    end

    if avatar != nil and avatar.size > 0
      percent += 50
    end

    if is_public
      percent += 10
    end

    if paypal_address.size > 0
      percent += 10
    end
    
    return percent

  end


end