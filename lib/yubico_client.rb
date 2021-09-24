# frozen_string_literal: true

require "securerandom"
require_relative "yubico_client/version"

module YubicoClient
  autoload :OTP, "yubico_client/OTP"

  class Error < StandardError; end
  # Your code goes here...
end
