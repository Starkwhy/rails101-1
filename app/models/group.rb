class Group < ApplicationRecord
  belongs_to :user
  has_many :posts
  validates :title, :description, presence: true

  has_many :GroupRelationship
  has_many :members, through: :group_relationship, source: :user
end
