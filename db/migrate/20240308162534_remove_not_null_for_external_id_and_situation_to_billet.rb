class RemoveNotNullForExternalIdAndSituationToBillet < ActiveRecord::Migration[7.1]
  def change
    change_column :billets, :external_id, :string, null: true
    change_column :billets, :customer_situation, :string, null: true
  end
end
