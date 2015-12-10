# coding: utf-8

class Event < ActiveRecord::Base

  validates :occurs_on, :presence => true
  validates :street, :presence => true
  validates :zipcode, :presence => true
  validates :city, :presence => true
  
  def set_coordinates
    res = Geokit::Geocoders::GoogleGeocoder.geocode(full_address)
    self.lat = res.lat
    self.lng = res.lng
    save
  end
  
  def full_address
    "#{street}, #{zipcode} #{city}, Belgium"
  end
  
end



# == Schema Information
#
# Table name: events
#
#  id           :integer(4)      not null, primary key
#  post_id      :integer(4)
#  occurs_on    :datetime
#  created_at   :datetime
#  updated_at   :datetime
#  link         :string(255)
#  street       :string(255)
#  zipcode      :string(255)
#  city         :string(255)
#  access       :string(255)
#  registration :string(255)
#  lat          :float
#  lng          :float
#

