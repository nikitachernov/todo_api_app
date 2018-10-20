class Tag < ApplicationRecord
  validates :title, presence: true, uniqueness: true
end
