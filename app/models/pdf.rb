class Pdf < ApplicationRecord
  has_many :pdf_pages
  mount_uploader :file, PdfUploader
end
