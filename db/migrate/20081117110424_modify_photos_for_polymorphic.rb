class ModifyPhotosForPolymorphic < ActiveRecord::Migration
  def self.up
    add_column :photos, :photoable_id, :integer
    add_column :photos, :photoable_type, :string
    Photo.find(:all).each do |photo|
      photo.photoable_id = photo.person_id
      photo.photoable_type = "Person"
      photo.save!
    end
    remove_column :photos, :person_id
  end

  def self.down
    add_column :photos, :person_id, :integer
    Gallery.find(:all).each do |photo|
      photo.person_id = photo.photoable_id
      photo.save!
    end
    remove_column :photos, :photoable_id
    remove_column :photos, :photoable_type
  end
end
