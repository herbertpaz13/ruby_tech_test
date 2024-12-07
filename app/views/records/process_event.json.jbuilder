# frozen_string_literal: true

json.records @records do |record|
  json.extract! record, :spam, :virus, :dns, :month, :delayed, :sender, :receiver
end
