json.extract! billet, :id, :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :customer_state, :customer_city_name, :customer_zipcode, :customer_address, :customer_neighborhood, :created_at, :updated_at
json.url billet_url(billet, format: :json)
