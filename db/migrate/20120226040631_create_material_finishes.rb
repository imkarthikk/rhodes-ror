class CreateMaterialFinishes < ActiveRecord::Migration
  def change
    create_table :material_finishes do |t|
      t.integer :material_id
      t.integer :finish_id
    end
  end
end