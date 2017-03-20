# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_one :profile
  has_many :posts
  has_many :comments, through: :posts

  validates :name, presence: true
end
