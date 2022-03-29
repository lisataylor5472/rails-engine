require 'rails_helper' 

RSpec.describe 'Merchants API' do
   describe 'index' do
      it 'returns a json object of all merchants' do
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
   end
end
 
    