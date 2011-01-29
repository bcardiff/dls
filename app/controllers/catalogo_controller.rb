class CatalogoController < ApplicationController
  
  def hombre
    
    @products = Product.all
    
    # TODO filtrar
    
    # TODO ordenar
    
    @total = to_cart_products @products
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
    @total = to_cart_products @products
  end

end
