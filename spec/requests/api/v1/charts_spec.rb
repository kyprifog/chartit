require 'spec_helper'

describe 'Charts API' do
  let(:user) { create(:user) }
  let(:auth) { {'HTTP_AUTHORIZATION' => basic_auth(user.email, user.password)} }

  context 'charts' do
    context 'list' do
      before(:each) do
        create_list(:chart, 10,  :with_slices, user: user)
      end
      it 'sends a list of charts' do
        get "/api/v1/charts", {}, auth
        json = JSON.parse(response.body)

        expect(response).to be_success
        expect(json).to include(
          'type' => 'charts'
        )
        first_chart = user.charts.first
        expect(json['charts'].count).to eq(10)
        expect(json['charts']).to include({
          'id' => first_chart.id,
          'name' => first_chart.name,
          'description' => first_chart.description,
          'slices' => first_chart.slices.map{|slice| slice.present }.as_json
        })
      end
    end

    context 'create' do

      it 'creates the chart' do
        params = {
          'name' => 'Test Chart',
          'description' => 'Test Description',
          'slices' => [
            {
              'name' => 'Test Slice 1',
              'percent' => 20
            },
            {
              'name' => 'Test Slice 2',
              'percent' => 30
            }
          ]
        }
        post "/api/v1/charts", params, auth
        json = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(json).to include(params)
      end

      it 'missing required parameters' do
        params = {'name' => 'Test Man'}
        post "/api/v1/charts", params, auth
        json = JSON.parse(response.body)

        expect(response.status).to eq(400)
        expect(json).to eq({"error" => 'description is missing'})
      end

    end
  end

  context 'chart' do

    context 'update' do
      let(:chart) {create(:chart, :with_slices, user: user)}

      it 'updates the chart' do
        params = {
          'name' => 'New Test Chart name',
          'description' => 'New Test Description',
          'slices' => [
            {
              'name' => 'New Test Slice 1',
              'percent' => 30
            },
            {
              'name' => 'New Test Slice 2',
              'percent' => 50
            },
            {
              'id' => chart.slices.first.id,
              'name' => 'New Test Slice 3',
              'percent' => 10
            },
            {
              '_destroy' => '1'
            }
          ]
        }
        put "/api/v1/charts/#{chart.id}", params, auth
        json = JSON.parse(response.body)

        expect(json["slices"].length).to eq(6)
        expect(response.status).to eq(200)
        expect(json["slices"]).to include(params['slices'][0])
        expect(json["slices"]).to include(params['slices'][1])
      end
    end
    it 'updates the chart' do
      params = {
        'name' => 'New Test Chart name',
        'description' => 'New Test Description',
        'slices' => [
          {
            'name' => 'New Test Slice 1',
            'percent' => 30
          },
          {
            'name' => 'New Test Slice 2',
            'percent' => 80
          },
          {
            'id' => chart.slices.first.id,
            'name' => 'New Test Slice 3',
            'percent' => 10
          },
          {
            '_destroy' => '1'
          }
        ]
      }
      put "/api/v1/charts/#{chart.id}", params, auth
      json = JSON.parse(response.body)

      expect(json["slices"].length).to eq(6)
      expect(response.status).to eq(200)
      expect(json["slices"]).to include(params['slices'][0])
      expect(json["slices"]).to include(params['slices'][1])
    end

    context 'delete' do
      let(:chart) {create(:chart, :with_slices, user: user)}

      it 'deletes' do
        delete "/api/v1/charts/#{chart.id}", {}, auth
        json = JSON.parse(response.body)
        expect(json["id"]).to eq(chart.id)
        expect(user.charts.count).to eq(0)
      end
    end

  end

end
