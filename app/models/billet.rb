class Billet < ApplicationRecord
  validates :expire_at, :customer_person_name, :customer_city_name,
    :customer_state, :customer_city_name, :customer_zipcode, :customer_address,
    :customer_neighborhood, :external_id, presence: :true
end
