require 'spec_helper'

describe Checklists::Question do
  describe '#show?' do
    let(:criteria_logic) do
      instance_double Checklists::CriteriaLogic, applies?: :result
    end

    it "delegates to the CriteriaLogic" do
      allow(Checklists::CriteriaLogic).to receive(:new)
        .with('criteria', 'selected_criteria') { criteria_logic }

      action = described_class.new('criteria' => 'criteria')
      expect(action.show?('selected_criteria')).to eq :result
    end
  end

  describe ".load_all" do
    subject { described_class.load_all }

    it "returns a list of questions with required fields" do
      subject.each do |question|
        expect(question.key).to be_present
        expect(question.text).to be_present
        expect(%w[single single_wrapped multiple multiple_grouped]).to include(question.type)
        expect(question.options).to be_a Array
      end
    end

    it "returns questions with unique keys" do
      keys = subject.map(&:key)
      expect(keys.uniq.count).to eq(keys.count)
    end

    it "returns questions that reference valid criteria" do
      subject.each do |question|
        expect(question.valid?).to be true
      end
    end
  end
end
