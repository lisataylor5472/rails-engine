require 'rails_helper' 

RSpec.describe 'Items API' do
   describe 'index' do
      it 'returns a json object of all items - happy path' do
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

      it 'returns an empty collection when no items exist - sad path' do
         get api_v1_items_path

         expect(response.status).to eq(200)
         no_items = JSON.parse(response.body, symbolize_names: true)

         expect(Item.count).to eq(0)
         expect(no_items[:data]).to eq([])
      end
   end
 
   describe 'show' do
      it 'returns the item data as a json object - happy path' do
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

      it 'returns a 404 status if item is not found - sad path' do
         get api_v1_item_path(1)

         no_item = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(404)

         expect(no_item).to have_key(:error)
         expect(no_item[:error][:exception]).to eq("Couldn't find Item with 'id'=1")
      end
   end
end
 
    