class CatalogoController < ApplicationController
  
  def hombre
    
    @productos = productos
    
    # TODO filtrar
    
    # TODO ordenar
    
    @total = aumentar_productos @productos
  end
  
  def carrito
    load_chart_data    
    @recipient = Recipient.new
  end
  
  def vaciar
    update_carrito nil
    redirect_to :action => :carrito
  end
  
  def confirmar
    @recipient = Recipient.new params[:recipient]
    
    if @recipient.valid?
      update_carrito nil
      render 'enviado'
    else
      load_chart_data
      render 'carrito'
    end
  end  
  
  def agregar
    @code = params[:code]
    @quantity = params[:quantity].to_i
    @sizes = params[:sizes]
    
    set_carrito @code, @quantity, @sizes
    
    @producto = productos.find { |i| @code == i[:code] }    
    aumentar_productos [@producto]
    @total = get_total
  end
  
protected

  def load_chart_data
    @productos = productos
    @total = aumentar_productos @productos
    @productos = @productos.select { |i| i[:in_chart] }
  end

end
