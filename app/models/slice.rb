class Slice < ActiveRecord::Base
  belongs_to :chart

  def present
    SliceSerializer.new(self).attributes
  end

  def present_data
    SliceDataSerializer.new(self).attributes
  end

end
