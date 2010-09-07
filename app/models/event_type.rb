class EventType < ActiveRecord::Base
  has_many :events
  has_many :photographers_event_types
  has_many :photographers, :through => :photographers_event_types

  def picture_count
    picture_count = 0
    events.each do |event|
      picture_count += event.approved_photos_count
    end
    return picture_count
  end

end
