class AddAttachmentPictureToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.has_attached_file :picture
    end
  end

  def self.down
    drop_attached_file :posts, :picture
  end
end
