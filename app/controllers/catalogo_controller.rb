class CatalogoController < ApplicationController
  
  def show
    @catalog = Catalog.where(["LOWER(name) = ?", params[:catalog_name].downcase]).first
     
    
    products_filter = { :catalog_id => @catalog.id }
    
    if params[:category_name].blank?
      @category = nil
    else
      @category = Category.where(["LOWER(name) = ?", params[:category_name].downcase]).first
      products_filter[:category_id] = @category.id
    end
    
    @products = Product.where(products_filter).all
    
    # TODO ordenar
    
    to_cart_products @products
    @total = get_total
  end
  
  def carrito
    load_cart_data    
    @recipient = Recipient.new
  end
  
  def vaciar
    update_cart nil
    redirect_to :action => :carrito
  end
  
  def confirmar
    @recipient = Recipient.new params[:recipient]
    load_cart_data
    
    if @recipient.valid?
      Notifier.purchase_to_merchant(@recipient, @products, @total).deliver
      Notifier.purchase_to_buyer(@recipient, @products, @total).deliver
      
      update_cart nil
      render 'enviado'
    else
      load_cart_data
      render 'carrito'
    end
  end  
  
  def agregar
    @code = params[:code]
    @quantity = params[:quantity].to_i
    @sizes = params[:sizes]
    
    set_cart @code, @quantity, @sizes
    
    @product = Product.find_by_code @code
    to_cart_products [@product]
    @total = get_total
  end
  
protected

  def load_cart_data
    @products = Product.find_all_by_code(get_cart.map { |i| i[:code]} )
    to_cart_products @products
    @total = get_total
  end

end
