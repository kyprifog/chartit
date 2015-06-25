class Chart < ActiveRecord::Base
  has_many :slices
  belongs_to :user

  accepts_nested_attributes_for :slices, :allow_destroy => true

  validate :slices_percent_valid

  def present
    ChartSerializer.new(self).attributes
  end

  def slices_percent_valid
    errors.add(:base, "Slices are not less than 100%") if slices.map(&:percent).map(&:to_i).sum > 100
  end

  def safe_name
    name.blank? ? "Unnamed" : name
  end
end
