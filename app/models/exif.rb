class Exif < ActiveRecord::Base
  def autoprice
    pixelnum = 0
    if width.to_i > height.to_i
      pixelnum = width.to_i
    else
      pixelnum = height.to_i
    end

    if pixelnum < 1024
      return 250
    end
    if pixelnum < 1920
      return 500
    end
    if pixelnum < 4896
      return 1000
    end
    if pixelnum >= 5184
      return 1200
    end
    
  end
end
