class ModifyGalleriesForPolymorphic < ActiveRecord::Migration
  def self.up
    add_column :galleries, :galleryable_id, :integer
    add_column :galleries, :galleryable_type, :string
    Gallery.find(:all).each do |gallery|
      gallery.galleryable_id = gallery.person_id
      gallery.galleryable_type = "Person"
      gallery.save!
    end
    remove_column :galleries, :person_id
  end

  def self.down
    add_column :galleries, :person_id, :integer
    Gallery.find(:all).each do |gallery|
      gallery.person_id = gallery.galleryable_id
      gallery.save!
    end
    remove_column :galleries, :galleryable_id
    remove_column :galleries, :galleryable_type
  end
end
