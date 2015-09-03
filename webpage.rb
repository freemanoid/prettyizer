require 'nokogiri'
require 'open-uri'

class Webpage
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def json_fields
    @json_fields ||= begin
      questions = page.css("form .ss-form-question")
      questions.inject([]) do |fields, question|
        label_text = question.css("label .ss-q-title")[0].children[0].text.strip
        required = question.css(".ss-item-required").any?
        description = question.css(".ss-secondary-text")[0].text
        field = { required: required, question: label_text, description: description }

        if question.css(".ss-radio").any?
          choices = question.css(".ss-choice-label").map { |l| {label: l.text} }
          name = format_name(question.css(".ss-choice-item input")[0].attributes["name"].value)
          type = "multiple_choice"

          field.merge!({ type: type, choices: choices, tags: [name] })
        elsif question.css(".ss-scale").any?
          name = format_name(question.css(".ss-scalerow-fieldcell input")[0].attributes["name"].value)
          type = "opinion_scale"

          field.merge!({ type: type, tags: [name] })
        elsif question.css(".ss-choices").any?
          choices = question.css(".ss-choice-label").map { |l| {label: l.text} }
          name = format_name(question.css(".ss-choice-item input")[0].attributes["name"].value)
          type = "multiple_choice"

          field.merge!({ type: type, choices: choices, tags: [name], allow_multiple_selections: true })
        elsif question.css(".ss-text").any?
          type = "short_text"
          name = format_name(question.css("input")[0].attributes["name"].value)

          field.merge!({ type: type, tags: [name] })
        elsif question.css(".ss-paragraph-text").any?
          type = "long_text"
          name = format_name(question.css("textarea")[0].attributes["name"].value)

          field.merge!({ type: type, tags: [name] })
        elsif question.css(".ss-select").any?
          choices = question.css("option").reject { |l| l.attributes["value"].value == "" }.map { |l| {label: l.text} }

          name = format_name(question.css("select")[0].attributes["name"].value)
          type = "dropdown"

          field.merge!({ type: type, choices: choices, tags: [name] })
        else
          raise UnsupportedFieldType
        end

        fields << field
        fields
      end
    end
  end

  def title
    page.title
  end

  def form_submit_url
    page.css("form")[0].attributes["action"].value
  end

  private def page
    @page ||= Nokogiri::HTML(open(url))
  end

  private def format_name(string)
    # Replace dots with colons because typeform doesn't support dots in tags
    string.gsub!(".", ":")
  end
end
