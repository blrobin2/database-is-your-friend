class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :bio
      t.date :birth
      t.date :death
      t.references :author, index: { unique: true }
      t.timestamps
    end
    add_foreign_key :profiles, :authors, on_delete: :restrict
  end
end
