class CatalogoController < ApplicationController
  
  def hombre
    
    @productos = productos
    
    # TODO filtrar
    
    # TODO ordenar
    
    aumentar_productos @productos
  end
  
  def mujer
  end
  
  
  def agregar
    @code = params[:code]
    @quantity = params[:quantity].to_i
    set_carrito @code, @quantity, ''

    @producto = productos.find { |i| @code == i[:code] }    
    aumentar_productos [@producto]
  end
  
end
