class ProspectsFile < ApplicationRecord
  belongs_to :user
  has_many :prospects
  has_one_attached :csv_file

  validates :email_index, presence: { message: "Please enter email_index" }
  validates :csv_file, presence: { message: "Please enter csv_file" }
  validates :force, inclusion: {in: [true, false]} 
  validates :has_headers, inclusion: {in: [true, false]} 
  validates :csv_file, file_size: { less_than_or_equal_to: 200.megabyte }, file_content_type: { allow: ['text/csv', 'text/plain'] }
end
