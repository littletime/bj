# frozen_string_literal: true

require_relative "app/version"
require_relative "app/table"

module App
  class Error < StandardError; end

  table = Table.new()
  table.start_game
end
