class ApplicationController < ActionController::Base
  protect_from_forgery

protected

  def productos
    [
      { :code => 'h34', :description => 'remera', :unit_price => 4, :thumbnail => 'images/h/34.png' },
      { :code => 'h35', :description => 'remera escote en v.', :unit_price => 6, :thumbnail => 'images/h/34.png' },
      { :code => 'h35', :description => 'pantalon', :unit_price => 7, :thumbnail => 'images/h/34.png' },
    ]
  end

  def set_carrito(code, quantity, details)
    puts 'sdf'
    c = carrito
    c.delete_if { |i| i[:code] == code }
    if quantity > 0
      c << { :code => code, :quantity => quantity, :details => details }
    end
    puts c.inspect
    
    update_carrito c
  end

  def aumentar_productos(productos)
    puts "carrito ", carrito.inspect
    productos.each do |p|
      en_carrito = carrito.find { |i| p[:code] == i[:code] }
      if en_carrito
        p[:in_chart] = true
        p[:quantity] = en_carrito[:quantity]
        p[:details] = en_carrito[:details]
      else
        p[:in_chart] = false
      end
    end
  end
  
  def carrito
    session[:carrito] || []
  end
  
  def update_carrito(valor)
    session[:carrito] = valor
  end
end
