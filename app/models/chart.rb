class Chart < ActiveRecord::Base
  has_many :slices
  belongs_to :user

  accepts_nested_attributes_for :slices

  validate :slices_percent_valid

  def present
    ChartSerializer.new(self).attributes
  end

  def slice_percent_valid
    slices.map(&:percent).sum <= 100
  end
end
