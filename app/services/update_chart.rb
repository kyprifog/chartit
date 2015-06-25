class UpdateChart

  def initialize(params, chart)
    @params = params
    if @params["slices_attributes"].nil?
      @params["slices_attributes"] = @params.delete("slices")
    end
    @chart = chart
  end

  def perform
    @chart.update_attributes(@params)
    @chart
  end
end
