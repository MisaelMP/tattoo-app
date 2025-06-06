# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  password_digest :text
#  user_name       :text
#  email           :text
#  name            :text
#  profile_image   :text
#  location        :text
#  latitude        :float
#  longitude       :float
#  phone           :text
#  is_artist       :boolean
#  blurb           :text
#  is_admin        :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :name, :user_name, :email, :location, presence: true
  validates :is_artist, inclusion: { in: [true,false]}
  validates :email, :name, :user_name, uniqueness: true, :on => :create
  validates :blurb, length: { maximum: 500,
       too_long: "Sorry, your blurb is too long! %{count} characters is the maximum allowed" }
  validates :password, length: { in: 6..32,
     too_long: "Sorry, your password is too long, %{count} characters is the maximum!",
      too_short: "Sorry, your password is too short, %{count} characters is the minimum!"   }, :on => :create
  has_secure_password
  after_validation :geocoder
  has_many :visits
  has_many :works
  has_many :customer_bookings, :class_name => 'Booking', :foreign_key => 'customer_id'
  has_many :artist_bookings, :class_name => 'Booking', :foreign_key => 'artist_id'

  private

  def geocoder
    results = Geocoder.search self.location
    self.latitude = results.first.coordinates.first
    self.longitude = results.first.coordinates.last
  end
end
 
