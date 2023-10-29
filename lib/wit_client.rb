module WitClient
  @client = Wit.new(access_token: Rails.application.credentials.wit[:access_token])

  class << self
    def parse(message)
      @resp = @client.message(message)

      return extract_intent, extract_duration
    end

    private
      def extract_intent
        if intent_confidence && intent_confidence > 0.90
          extracted_intent
        else
          'Unknown'
        end
      end

      def extract_duration
        if duration_confidence && duration_confidence > 0.90
          extracted_duration
        else
          nil
        end
      end

      def duration_confidence
        @resp["entities"]["wit$duration:duration"]&.first&.fetch("confidence")
      end

      def extracted_duration
        @resp["entities"]["wit$duration:duration"]&.first&.dig("normalized", "value")
      end

      def intent_confidence
        @resp["intents"]&.first&.fetch("confidence")
      end

      def extracted_intent
        @resp["intents"]&.first&.fetch("name")
      end
  end
end
