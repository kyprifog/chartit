class ChartSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :slices

  def slices
    object.slices.map(&:present)
  end
end
