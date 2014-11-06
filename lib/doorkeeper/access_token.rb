# Extend Doorkeeper::AccessToken to add a new access token type:
#   urn:peatio:api:v2:token

module Doorkeeper
  class AccessToken

    attr_accessor :api_token

    after_create :link_api_token

    def token_type
      'urn:peatio:api:v2:token'
    end

    private

    def generate_token
      member         = Member.find resource_owner_id
      self.api_token = member.api_tokens.create!(label: application.name, scopes: scopes.to_s, expire_at: expires_in.since(Time.now))
      self.token     = api_token.to_oauth_token
    end

    def link_api_token
      api_token.update_attributes(oauth_access_token_id: id)
    end

  end
end