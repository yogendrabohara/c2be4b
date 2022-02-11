class CreateProspectsFiles < ActiveRecord::Migration[6.1]
  def change
    create_table :prospects_files do |t|
      t.string :file_path
      t.integer :email_index
      t.integer :first_name_index
      t.integer :last_name_index
      t.boolean :force
      t.boolean :has_headers
      t.integer :total
      t.integer :done
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
