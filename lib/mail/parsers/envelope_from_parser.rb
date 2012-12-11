module Mail::Parsers
  class EnvelopeFromParser
    include Mail::Utilities

    def parse(string)
      envelope_from = Data::EnvelopeFromData.new
      if string.blank?
        return envelope_from
      end

      parser = Treetops::EnvelopeFromParser.new
      if tree = parser.parse(string)
        envelope_from.address = tree.addr_spec.text_value.strip
        envelope_from.ctime_date = tree.ctime_date.text_value
      else
        raise Mail::Field::ParseError.new(Mail::EnvelopeFromElement, string, parser.failure_reason)
      end

      envelope_from
    end
  end
end