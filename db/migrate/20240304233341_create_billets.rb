class CreateBillets < ActiveRecord::Migration[7.1]
  def change
    create_table :billets do |t|
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.date :expire_at, null: false
      t.string :customer_person_name
      t.string :customer_cnpj_cpf, null: false
      t.string :customer_state, null: false
      t.string :customer_city_name, null: false
      t.string :customer_zipcode, null: false
      t.string :customer_address, null: false
      t.string :customer_neighborhood, null: false
      t.string :external_id, null: false

      t.timestamps
    end
  end
end
