class Product < ActiveRecord::Base
  belongs_to :catalog
  belongs_to :category

  def thumbnail
    "catalogo/art_#{code.reverse.chop.reverse}.jpg"
  end
end
