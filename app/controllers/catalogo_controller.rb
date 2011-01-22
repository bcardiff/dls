class CatalogoController < ApplicationController
  
  def hombre
    
    @productos = productos
    
    # TODO filtrar
    
    # TODO ordenar
    
    aumentar_productos @productos
  end
  
  def carrito
    @productos = productos
    aumentar_productos @productos
    @productos = @productos.select { |i| i[:in_chart] }
  end
  
  
  def agregar
    @code = params[:code]
    @quantity = params[:quantity].to_i
    @sizes = params[:sizes]
    
    set_carrito @code, @quantity, @sizes

    @producto = productos.find { |i| @code == i[:code] }    
    aumentar_productos [@producto]
  end
  
end
