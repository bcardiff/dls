class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :build_products_menu_unless_xhr
  before_filter :calcular_total
  
protected

  def calcular_total
    @total = get_total unless request.xhr?
  end

  def build_products_menu_unless_xhr
    build_products_menu unless request.xhr?
  end

  def build_products_menu
    data = Product.joins([:catalog, :category])\
      .select("catalog_id, #{Catalog.table_name}.name as catalog_name, category_id, #{Category.table_name}.name as category_name, count(*) as count")\
      .group("catalog_id, #{Catalog.table_name}.name, category_id, #{Category.table_name}.name")\
      .order("catalog_name, category_name")\
      .map(&:attributes)
    data.recursively_symbolize_keys!
    
    @products_menu = []
    
    data.group_by { |d| d[:catalog_id] }.each do |catalog_id, categories|
      
      @products_menu << { :id => catalog_id, 
          :name => categories.first[:catalog_name],
          :count => categories.sum { |c| c[:count] },
          :categories => categories.map {|c| { :id => c[:category_id] , :name => c[:category_name], :count => c[:count] } }
      }
    end
  end

  def set_cart(code, quantity, sizes)
    c = get_cart
    c.delete_if { |i| i[:code] == code }
    if quantity > 0
      c << { :code => code, :quantity => quantity, :sizes => sizes }
    end
    
    update_cart c
  end

  def to_cart_products(products)
    products.each do |p|
      in_cart = get_cart.find { |i| p.code == i[:code] }
      if in_cart
        p.define_accessor :in_cart, true
        p.define_accessor :quantity, in_cart[:quantity]
        p.define_accessor :sizes, in_cart[:sizes]
      else
        p.define_accessor :in_cart, false
        p.define_accessor :quantity, ''
        p.define_accessor :sizes, ''        
      end
    end
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
