require 'rails_helper' 

RSpec.describe 'Merchants API' do
   describe 'index' do
      it 'returns a json object of all merchants - happy path' do
         create_list(:merchant, 3)
   
         get api_v1_merchants_path
   
         expect(response.status).to eq(200)
         merchants = JSON.parse(response.body, symbolize_names: true)
   
         expect(merchants).to have_key(:data)
         expect(merchants[:data].count).to eq(3)
    
         merchants[:data].each do |merchant|
            expect(merchant[:id]).to be_a String
            expect(merchant[:attributes][:name]).to be_a String
         end
      end

      it 'returns an empty collection when no merchants exist - sad path' do
         get api_v1_merchants_path

         expect(response.status).to eq(200)
         no_merchants = JSON.parse(response.body, symbolize_names: true)

         expect(Merchant.count).to eq(0)
         expect(no_merchants[:data]).to eq([])
      end
   end
 
   describe 'show' do
      it 'returns the merchant data as a json object - happy path' do
        id = create(:merchant).id

        get api_v1_merchant_path(id)

        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(200)

        expect(merchant).to have_key(:data)
        expect(merchant[:data][:id]).to eq(id.to_s)

        expect(merchant[:data][:id]).to be_a String
        expect(merchant[:data][:attributes][:name]).to be_a String
      end

      it 'returns a 404 status if merchant is not found - sad path' do
         get api_v1_merchant_path(1)

         no_merchant = JSON.parse(response.body, symbolize_names: true)

         expect(response.status).to eq(404)

         expect(no_merchant).to have_key(:error)
         expect(no_merchant[:error][:exception]).to eq("Couldn't find Merchant with 'id'=1")
      end
   end
end
 
    