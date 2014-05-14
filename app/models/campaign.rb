class Campaign < ActiveRecord::Base
  belongs_to :organization
  has_many :perks
  has_many :comments
  has_many :updates
  has_many :contributions
  has_many :milestones

  accepts_nested_attributes_for :organization

  CATEGORIES = [:education, :social, :health]

  validates :category, inclusion: { in: CATEGORIES.map(&:to_s) }
  validates :name, :description, :goal, :minimum, :short_description, :locality, presence: true
  validates :minimum, :goal, numericality: { greater_or_equal_to: 1 }
  validates :deadline, timeliness: { on_or_after: -> { Date.current } }

end
