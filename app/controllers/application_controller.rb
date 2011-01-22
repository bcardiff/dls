class ApplicationController < ActionController::Base
  protect_from_forgery

protected

  def productos
    products = YAML.load_file(File.join(Rails.root,'config','products.yml'))
    products.recursively_symbolize_keys!
  end

  def set_carrito(code, quantity, sizes)
    c = get_carrito
    c.delete_if { |i| i[:code] == code }
    if quantity > 0
      c << { :code => code, :quantity => quantity, :sizes => sizes }
    end
    
    update_carrito c
  end

  def aumentar_productos(productos)
    productos.each do |p|
      en_carrito = get_carrito.find { |i| p[:code] == i[:code] }
      if en_carrito
        p[:in_chart] = true
        p[:quantity] = en_carrito[:quantity]
        p[:sizes] = en_carrito[:sizes]
      else
        p[:in_chart] = false
      end
    end
  end
  
  def get_carrito
    session[:carrito] || []
  end
  
  def update_carrito(valor)
    session[:carrito] = valor
  end
end
