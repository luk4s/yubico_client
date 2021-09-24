require "base64"

module YubicoClient
  # Verify OTP against Yubico Cloud
  # @see https://developers.yubico.com/yubikey-val/Getting_Started_Writing_Clients.html
  class OTP

    # @param (see #initialize)
    def self.valid?(*args)
      client = new(*args)
      client.response_data["status"] == "OK" && client.valid?
    end

    # @param [String] otp
    # @see https://developers.yubico.com/yubikey-val/Getting_Started_Writing_Clients.html#_binding_an_otp_to_an_identity
    # @note ...Since the rest of the OTP is always 32 characters, the method to extract the identity is to remove 32 characters from the end and then use the remaining string, which should be 2-16 characters, as the YubiKey identity
    def self.key_id(otp)
      otp[0, otp.size - 32]
    end

    # @param [String] otp obtain from Yubikey
    # @param [String] client_id api_key ID for Yubico cloud
    # @param [String] secret see https://upgrade.yubico.com/getapikey/
    def initialize(otp, client_id:, secret:)
      @otp = otp
      @client_id = client_id
      @secret = secret
      @timestamp = Time.now.utc.iso8601
    end

    def nonce
      @nonce ||= SecureRandom.hex 16
    end

    def params
      { id: @client_id, otp: @otp, nonce: nonce }
    end

    def query_params
      @query_params ||= params.map { |k, v| "#{k}=#{v.strip}" }.sort
    end

    def request_signature
      hmac = OpenSSL::HMAC.digest('sha1', Base64.decode64(@secret), query_params.join("&").strip)
      Base64.encode64(hmac).strip
    end

    # @see https://developers.yubico.com/yubikey-val/Getting_Started_Writing_Clients.html
    # @return [Hash]
    def response_data
      return @response_data if @response_data

      uri = URI('https://api.yubico.com/wsapi/2.0/verify')
      uri.query = URI.encode_www_form(params.merge("h" => request_signature))

      response = Net::HTTP.get_response(uri)
      raise Error, response unless response.is_a?(Net::HTTPSuccess)

      @response_data = response.body.split(" ").each_with_object({}) { |i, obj| m = i.match(/^(\w+)=(.*)/); obj.store(m[1], m[2].strip) }
    end

    def valid?
      data = response_data
      signature = data.delete("h")
      response_string = data.map { |k, v| "#{k}=#{v}" }.sort.join("&")
      hmac = OpenSSL::HMAC.digest('sha1', Base64.decode64(@secret.strip), response_string)
      signature == Base64.encode64(hmac).strip
    end

  end
end
