class Post < ActiveRecord::Base
  attr_accessor :picture_base64
  attr_accessible :name, :picture, :picture_base64

  if Rails.env == 'production'
    has_attached_file :picture,
      :storage => :s3,
      :s3_credentials => "#{::Rails.root.to_s}/config/s3.yml",
      :path => ":attachment/:id/:style.:extension"
  else
    has_attached_file :picture
  end
end
