module API
  module V1
    class Charts < Grape::API
      include API::V1::Defaults
      resource :charts do
        desc "Return list of charts"
        get do
          {"type" => "charts"}.merge( { "charts" => user.charts.map{ |chart| chart.present } } )
        end

        desc "Create a chart"
        params do
          requires :name, type: String, desc: "Chart name"
          requires :description, type: String, desc: "Chart description"
          optional :slices, type: Array, desc: "Chart slices" do
            requires :name, type: String, desc: "Slice name"
            requires :percent, type: Integer, desc: "Slice percentage"
          end
        end

        post do
          chart = CreateChart.new(@user, permitted_params).perform

          {"type" => "create_chart"}.merge(chart.present)
        end

        route_param :id do
          before{@chart = user.charts.find(params[:id]) } 

          desc "Fetch a chart"
          get do
            {"type" => "chart"}.merge(@chart.present)
          end

          desc "Update a chart"
          params do
            optional :name, type: String, desc: "Chart name"
            optional :description, type: String, desc: "Chart description"
            optional :slices, type: Array, desc: "Chart slices" do
              optional :id, type: Integer, desc: "Slice id"
              optional :name, type: String, desc: "Slice name"
              optional :percent, type: Integer, desc: "Slice percentage"
              optional :_destroy, type: Integer, desc: "Slice destroy option"
            end
          end

          put do
            chart = UpdateChart.new(permitted_params, @chart).perform
            {"type" => "update_chart"}.merge(chart.present)
          end

          desc "Deletes a chart"
          delete do
            {"type" => "delete_chart"}.merge({"id" => @chart.delete.id})
          end

        end
      end
    end
  end
end
