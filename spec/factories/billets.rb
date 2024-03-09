FactoryBot.define do
  factory :billet do
    amount { 10.21 }
    expire_at { '2025-03-05'.to_date }
    customer_person_name { "Vitor Cabreira Filho" }
    customer_cnpj_cpf { '20968985017' }
    customer_state { 'RJ' }
    customer_city_name { 'Agrestina' }
    customer_zipcode { '05318-713' }
    customer_address { 'Rua Santa Rosa' }
    customer_neighborhood { 'Stella Maris' }
    sequence(:external_id){ |n| "123321#{n}" }
    sequence(:customer_number){ |n| "43#{n}" }
    customer_complement { 'Vizinho da casa ao lado' }
    customer_situation { 'opened' }

    trait :billet_with_faker do
      amount { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
      expire_at { generate_expire_at }
      customer_person_name { Faker::Name.name }
      customer_cnpj_cpf {Faker::IDNumber.brazilian_citizen_number}
      customer_state { Faker::Address.state_abbr }
      customer_city_name { Faker::Address.city }
      customer_zipcode { Faker::Address.zip_code }
      customer_address { Faker::Address.street_name }
      customer_neighborhood {  Faker::Address.community }
      sequence(:external_id){ Faker::Number.number(digits: 4) }
      sequence(:customer_number){ Faker::Number.number(digits: 2)}
      customer_complement { 'Vizinho da casa ao lado' }
      customer_situation { %w[generating opened paid canceled].sample }
    end
  end
end

def generate_expire_at
  loop do
    date = Faker::Date.forward(days: 365)

    break date if (1..5).cover?(date.wday)
  end
end
