# frozen_string_literal: true
require "base64"
RSpec.describe YubicoClient::OTP do
  let(:otp) { "vvvvvvcurikvhjcvnlnbecbkubjvuittbifhndhn" }
  let(:client_id) { "123456" }
  let(:secret) { Base64.encode64 "supersecret=" }
  let(:valid_response) do
    <<~EOF
      h=vjhFxZrNHB5CjI6vhuSeF2n46a8=
      t=2010-04-23T20:34:51Z0678
      otp=cccccccbcjdifctrndncchkftchjlnbhvhtugdljibej
      nonce=aef3a7835277a28da831005c2ae3b919e2076a62
      sl=75
      status=OK
    EOF
  end
  let(:invalid_response) do
    <<~EOF
      h=XXXXXXXXXX=
      t=2010-04-23T20:34:51Z0678
      otp=cccccccbcjdifct
      nonce=aef3a7835277a
      sl=75
      status=BAD_OTP
    EOF
  end

  subject(:client) { described_class.new otp, client_id: client_id, secret: secret }

  describe "#key_id" do
    it { expect(described_class.key_id(otp)).to eq "vvvvvvcu" }
  end

  describe "query_params" do
    subject { client.query_params }
    it { is_expected.to include "id=#{123456}", "otp=#{otp}" }
  end

  describe "#request_signature" do
    subject { client.request_signature }
    it { is_expected.not_to be_empty }
  end

  describe "#response_data" do
    subject { client.response_data }
    before do
      stub_request(:get, %r{https://api.yubico.com/wsapi/2.0/verify}).
        to_return(status: 200, body: response)
    end

    context "with valid response" do
      let(:response) { valid_response }

      it { is_expected.to be_a Hash }
      it { is_expected.to include "status" => "OK" }
    end
    context "with invalid response" do
      let(:response) { invalid_response }
      it { is_expected.to include "status" => "BAD_OTP" }
    end
  end

  describe "#valid?" do
    subject { client.valid? }
    before do
      stub_request(:get, %r{https://api.yubico.com/wsapi/2.0/verify}).
        to_return(status: 200, body: response)
    end
    let(:response) { invalid_response }
    it { is_expected.to be_falsey }
  end
end
