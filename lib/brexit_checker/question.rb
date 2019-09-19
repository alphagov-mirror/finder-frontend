class BrexitChecker::Question
  include ActiveModel::Validations

  CONFIG_PATH = Rails.root.join('lib', 'brexit_checker', 'questions.yaml')

  validates_presence_of :key, :text
  validates_numericality_of :index, only_integer: true
  validates_inclusion_of :type, in: %w(single single_wrapped multiple multiple_grouped)
  validate { errors.add("Options is not an array") unless options.is_a? Array }

  attr_reader :key, :text, :description, :hint_title, :hint_text,
              :options, :type, :criteria, :index

  def initialize(attrs)
    attrs.each { |key, value| instance_variable_set("@#{key}", value) }
    validate!
  end

  def multiple?; type == "multiple" end

  def multiple_grouped?; type == "multiple_grouped" end

  def single_wrapped?; type == "single_wrapped" end

  def self.find_by_key(key)
    load_all.find { |q| q.key == key }
  end

  def show?(selected_criteria)
    BrexitChecker::Criteria::Evaluator.evaluate(criteria, selected_criteria)
  end

  def all_values
    sub_options = options.flat_map(&:sub_options)
    (options + sub_options).map(&:value).compact
  end

  def self.load(params)
    parsed_params = params.dup
    parsed_params['text'] = params['question']
    parsed_params['options'] = Option.load_all(params['options'])
    parsed_params['type'] = params['question_type']
    new(parsed_params)
  end

  def self.load_all
    @load_all = nil if Rails.env.development?
    @load_all ||= YAML.load_file(CONFIG_PATH)['questions'].map { |q| load(q) }
  end
end
