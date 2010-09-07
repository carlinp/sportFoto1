class CartController < ApplicationController
  layout "general", :except => [:show, :add, :remove, :bundle, :summary, :paylink]
  # POST
  def add
    @photo = Photo.find params[:id]
    if @photo
      session[:cart] = Array.new unless ( session[:cart] != nil )

      session[:cart] << @photo.id
      session[:cart].uniq!
      if session[:cart_id] != nil
        cartItem = CartItem.all(:conditions=>{:cart_id=>session[:cart_id], :photo_id=>@photo.id})
        if cartItem.count == 0
          CartItem.create(:photo_id=>@photo.id, :cart_id=>session[:cart_id])
        end
      end

    end
    render :nothing => true
  end

  # DELETE
  def remove
    if params[:id] == "all"
      session[:cart] = Array.new
      if session[:cart_id] != nil
        #remove database
        CartItem.destroy_all(:cart_id=>session[:cart_id])
        session[:cart_id] = nil
      end
    else
      session[:cart].delete(params[:id].to_i) if ( session[:cart] != nil )
      if session[:cart_id] != nil
        CartItem.destroy_all(:cart_id=>session[:cart_id], :photo_id=>params[:id])
      end
    end
    render :nothing => true
  end

  def show
    if ( session[:cart] != nil  )
      @photos = Photo.find session[:cart]
    else
      @photos = Array.new
    end
  end

  def summary
    render :partial => "shared/cart_count"
  end

  def checkout
    if ( session[:cart] != nil  )
      @photos = Photo.find session[:cart]
      @cart = Cart.new
      if ( session[:cart_id] == nil and session[:cart].size > 0)
        @cart.carthash = Digest::MD5.hexdigest( @photos.to_a.sum(&:price).to_s + Time.now.to_s )
        if ( @cart.save )
          @photos.each do |item|
            cart_item = CartItem.new
            cart_item.photo=item
            cart_item.cart=@cart
            cart_item.save!
          end
        end
        session[:cart_id] = @cart.id
      else
        if ( session[:cart].size > 0 and session[:cart_id] > 0 )
          @cart = Cart.find session[:cart_id]
        else
          @cart = Cart.new
          @cart.carthash=""
        end
      end
    else
      @photos = Array.new
      @cart = Cart.new
      @cart.carthash = ""
    end
  end

  def download
    @cart = Cart.find_last_by_carthash params[:id]

    if (@cart.total_price == 0)
      @cart.is_paid = true
      @cart.save
    end

    if @cart.is_paid and session[:cart_id] == @cart.id
      session[:cart] = nil
      session[:cart_id] = nil
    end
    if @cart == nil
      render :partial => "shared/page403", :layout => "general"
    end
  end

  def bundle
    @cart = Cart.find params[:id]
    if @cart == nil
      render :partial => "shared/page403"
    else
      if !@cart.is_zipped
        if (@cart.zipfile == nil)
          @cart.zipfile = @cart.carthash+".zip"
          @cart.save
        end
        @cart.bundle
      end
    end
  end

  def serve
    @cart = Cart.find_last_by_carthash params[:id]
    if @cart == nil
      render :partial => "shared/page403"
    else
      if @cart.is_zipped
        send_file File.join(RAILS_ROOT,'data',@cart.zipfile), :type=>"application/zip"
      end
    end
  end

  def summary
    if ( session[:cart_id] != nil )
      @cart = Cart.find session[:cart_id]
    else
      render :nothing
    end
  end

  def paylink
    if ( session[:cart_id] != nil )
      @cart = Cart.find session[:cart_id]
    else
      render :nothing
    end
  end

end