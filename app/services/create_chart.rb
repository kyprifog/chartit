class CreateChart

  def initialize(user, params)
    @user = user
    @params = params
    @params["slices_attributes"] = @params.delete("slices")
  end

  def perform
    chart = @user.charts.new(@params)
    chart.save!
    chart
  end
end
