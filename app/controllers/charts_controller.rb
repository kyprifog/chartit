class ChartsController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource :chart, :except => [:index, :new, :create]
  skip_before_filter :verify_authenticity_token, :only => :destroy

  def index
  end

  def new
    @chart = current_user.charts.build
    render :edit
  end

  def show
    @data = ChartDataSerializer.new(@chart).attributes
  end

  def update
    @chart = UpdateChart.new(chart_params, @chart).perform
    check_and_render(@chart)
  end

  def destroy
    @chart.destroy
    redirect_to charts_path
  end

  def edit
  end

  def create
    @chart = CreateChart.new(current_user, chart_params).perform
    check_and_render(@chart)
  end

  private

  def chart_params
    params.require(:chart).permit!
  end

  def check_and_render(chart)
    if chart.valid?
      redirect_to chart_path(chart)
    else
      flash.now[:error] = chart.errors.full_messages.to_sentence
      render :edit
    end
  end


end
