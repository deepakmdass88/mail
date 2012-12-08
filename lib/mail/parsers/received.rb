# Autogenerated from a Treetop grammar. Edits may be lost.


module Mail
  module Received
    include Treetop::Runtime

    def root
      @root ||= :primary
    end

    include RFC5322

    def _nt_primary
      start_index = index
      if node_cache[:primary].has_key?(index)
        cached = node_cache[:primary][index]
        if cached
          cached = SyntaxNode.new(input, index...(index + 1)) if cached == true
          @index = cached.interval.end
        end
        return cached
      end

      r0 = _nt_received

      node_cache[:primary][start_index] = r0

      r0
    end

  end

  class ReceivedParser < Treetop::Runtime::CompiledParser
    include Received
  end

end
