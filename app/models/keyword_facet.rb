class KeywordFacet
  def initialize(keywords)
    @keywords = keywords
  end

  def sentence_fragment
    return nil unless has_filters?

    {
      'key' => key,
      'preposition' => 'containing',
      'values' => value_fragments,
      'word_connectors' => {}
    }
  end

  def has_filters?
    keywords.present?
  end

  def key
    'keywords'
  end

  def value
    [keywords]
  end

private

  attr_reader :keywords

  def value_fragments
    keyword_array = keywords.split(" ")
    keyword_fragments = []

    keyword_array.each do |keyword|
      keyword_fragments << {
        'label' => keyword,
        'parameter_key' => key,
        'name' => 'keywords',
        'value' => keyword
      }
    end

    keyword_fragments
  end
end
