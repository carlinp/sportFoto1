class PhotographersEventType < ActiveRecord::Base
  belongs_to :photographer
  belongs_to :event_type
end
