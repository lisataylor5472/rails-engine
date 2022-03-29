class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name

  def self.invalid_params
    { error: { exception: 'No params or invalid params given' } }
  end
end