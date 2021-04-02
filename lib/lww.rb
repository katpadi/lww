# frozen_string_literal: true

require "lww/version"
require "awesome_print"

require 'lww/element'
require 'lww/element_set'

module Lww
  class Error < StandardError; end

  def self.ts
    (Time.now.utc.to_r * 1_000_000).to_i
  end
end
