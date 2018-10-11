class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> {order(created_at: :desc)}
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.max_content}
  validate :picture_size
  scope :feed, -> (id){where("user_id = ?", id)}

  private

    def picture_size
      errors.add(:picture, I18n.t(".less") ) if picture.size > Settings.micropost.max_file.megabytes
    end
end
