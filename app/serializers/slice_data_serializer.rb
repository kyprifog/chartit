class SliceDataSerializer < ActiveModel::Serializer
  attributes :name, :y

  def y
    object.percent.to_f
  end

end
