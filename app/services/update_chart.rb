class UpdateChart

  def initialize(params, chart)
    @params = params
    @params["slices_attributes"] = @params.delete("slices")
    @chart = chart
  end

  def perform
    @chart.update_attributes(@params)
    @chart
  end
end
