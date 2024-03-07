class AddComplemetAndNumberAndSituationToBillet < ActiveRecord::Migration[7.1]
  def change
    add_column :billets, :customer_number, :string
    add_column :billets, :customer_complement, :string
    add_column :billets, :customer_situation, :string, null: false
  end
end
