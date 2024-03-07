# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_03_06_004834) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "billets", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.date "expire_at", null: false
    t.string "customer_person_name"
    t.string "customer_cnpj_cpf", null: false
    t.string "customer_state", null: false
    t.string "customer_city_name", null: false
    t.string "customer_zipcode", null: false
    t.string "customer_address", null: false
    t.string "customer_neighborhood", null: false
    t.string "external_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "customer_number"
    t.string "customer_complement"
    t.string "customer_situation", null: false
  end

end
