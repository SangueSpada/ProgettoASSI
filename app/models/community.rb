class Community < ApplicationRecord
    has_many :participations, dependent: :destroy
    has_many :users, through: :participations, dependent: :destroy
    has_many :community_posts, dependent: :destroy

    has_many :taggables, dependent: :destroy
    has_many :tags
end