# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

products = YAML.load_file(File.join(Rails.root,'config','products.yml'))
products.recursively_symbolize_keys!

products.each do |p|
  
  Product.create :code => p[:code], 
      :catalog => Catalog.find_or_create_by_name(p[:catalog]),
      :category => Category.find_or_create_by_name(p[:category]),
      :description => p[:description],
      :unit_price => p[:unit_price]
  
end