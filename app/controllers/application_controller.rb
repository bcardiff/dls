class ApplicationController < ActionController::Base
  protect_from_forgery

protected

  def set_cart(code, quantity, sizes)
    c = get_cart
    c.delete_if { |i| i[:code] == code }
    if quantity > 0
      c << { :code => code, :quantity => quantity, :sizes => sizes }
    end
    
    update_cart c
  end

  def to_cart_products(products)
    total = 0

    products.each do |p|
      in_cart = get_cart.find { |i| p.code == i[:code] }
      if in_cart
        p.define_accessor :in_cart, true
        p.define_accessor :quantity, in_cart[:quantity]
        p.define_accessor :sizes, in_cart[:sizes]
        
        total += in_cart[:quantity] * p.unit_price if in_cart
      else
        p.define_accessor :in_cart, false
        p.define_accessor :quantity, ''
        p.define_accessor :sizes, ''
        
      end
    end
    
    total
  end
  
  def get_cart
    session[:cart] || []
  end
  
  def update_cart(valor)
    session[:cart] = valor
  end
  
  def get_total
    total = 0
    
    products = Product.find_all_by_code(get_cart.map { |i| i[:code]} )
    
    products.each do |p|
      in_cart = get_cart.find { |i| p.code == i[:code] }
      total += in_cart[:quantity] * p.unit_price
    end
    
    total
  end
end
