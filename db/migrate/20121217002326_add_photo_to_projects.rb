class AddPhotoToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :photo_file_name, :string
    add_column :projects, :photo_content_type, :string
    add_column :projects, :photo_file_size, :integer
  end
end
