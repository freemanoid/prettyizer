class UnsupportedFieldType < StandardError; end

class TypeformCallback
  attr_reader :body

  def initialize(body)
    @body = body
  end

  def answers
    json["answers"].inject({}) do |result, answer|
      case answer["type"]
      when "text"
        value = answer["value"]
      when "choice"
        value = answer["value"]["label"]
      when "number"
        value = answer["value"]["amount"]
      else
        raise UnsupportedFieldType, answer["type"]
      end

      key = deserialize_answer(answer["tags"][0])
      if result[key]
        result[key] = Array(result[key])
        result[key] << value
      else
        result[key] = value
      end

      result
    end
  end

  private def json
    @json ||= JSON.parse(body)
  end

  private def deserialize_answer(string)
    string.gsub(":", ".")
  end
end
