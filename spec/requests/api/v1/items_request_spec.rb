require 'rails_helper' 

RSpec.describe 'Items API' do
   describe 'index' do
      it 'GET all items - happy path' do
         create_list(:item, 3)
   
         get api_v1_items_path
   
         expect(response.status).to eq(200)
         items = JSON.parse(response.body, symbolize_names: true)
   
         expect(items).to have_key(:data)
         expect(items[:data].count).to eq(3)
    
         items[:data].each do |item|
            expect(item[:id]).to be_a String
            expect(item[:attributes][:name]).to be_a String
         end
      end

      it 'GET all items - sad path' do
         get api_v1_items_path

         expect(response.status).to eq(200)
         no_items = JSON.parse(response.body, symbolize_names: true)

         expect(Item.count).to eq(0)
         expect(no_items[:data]).to eq([])
      end
   end
 
   describe 'show' do
      it 'GET one item - happy path' do
         id = create(:item).id
         get api_v1_item_path(id)
 
         expect(response.status).to eq(200)
         item = JSON.parse(response.body, symbolize_names: true)
 
         expect(item).to have_key(:data)
         expect(item[:data][:id]).to eq(id.to_s)
 
         expect(item[:data][:id]).to be_a String
         expect(item[:data][:attributes][:name]).to be_a String
         expect(item[:data][:attributes][:description]).to be_a String
         expect(item[:data][:attributes][:unit_price]).to be_a Float
         expect(item[:data][:attributes][:merchant_id]).to be_an Integer
      end

      it 'GET one item - sad path' do
         get api_v1_item_path(1)

         no_item = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(404)

         expect(no_item).to have_key(:error)
         expect(no_item[:error][:exception]).to eq("Couldn't find Item with 'id'=1")
      end
   end

   describe 'create' do
      it 'POST create (then delete) one item - happy path' do
         merchant_id = create(:merchant).id
         item_params = ({
                     name: 'Gameboy',
                     description: 'Handheld gaming console',
                     unit_price: 100.99,
                     merchant_id: merchant_id,
                     })
         headers = {"CONTENT_TYPE" => "application/json"}
         post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)
      
         new_item = Item.last 

         expect(response.status).to eq(201)
         expect(new_item.name).to eq(item_params[:name])
         expect(new_item.description).to eq(item_params[:description])
         expect(new_item.unit_price).to eq(item_params[:unit_price])
         expect(new_item.merchant_id).to eq(item_params[:merchant_id])
        

         delete api_v1_item_path(Item.last)
         expect(response.status).to eq(204)
      end

      it 'create errors if attributes are incorrect - sad path' do
         merchant_id = create(:merchant).id
         item_params = ({
                     name: 'Gameboy',
                     description: 'Handheld gaming console',
                     merchant_id: merchant_id,
                     })
         headers = {"CONTENT_TYPE" => "application/json"}
         post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

         expect(response.status).to eq(400)
      end

      it 'ignores attributes that are not allowed' do
         merchant_id = create(:merchant).id
         item_params = ({
                     name: 'Gameboy',
                     description: 'Handheld gaming console',
                     unit_price: 100.99,
                     merchant_id: merchant_id,
                     extra_attribute: 'bonus stuff'
                     })
         headers = {"CONTENT_TYPE" => "application/json"}
         post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)
         item = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(201)
         expect(item[:data][:attributes]).to_not have_key(:non_permitted_attribute)
      end
   end
end
 
    