class RemoveFilePathFromProspectsFiles < ActiveRecord::Migration[6.1]
  def change
    remove_column :prospects_files, :file_path, :string
  end
end
