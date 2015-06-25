class ChartDataSerializer < ActiveModel::Serializer
  attributes :name, :slices

  def slices
    slice_response = {colorByPoint: true}
    slice_response["data"] = object.slices.map(&:present_data)
    slice_response["data"] = add_negative_space(slice_response["data"])
    [slice_response].to_json
  end

  private

  def add_negative_space(data)
    sum = data.map{|slice| slice[:y] }.sum
    if sum < 100
      diff = 100 - sum
      deadspace = {name: "undefined", y: (100-sum), color: 'white'}
      data << deadspace
    end
    data
  end
end
