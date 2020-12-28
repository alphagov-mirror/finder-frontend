require "spec_helper"

RSpec.describe BrexitChecker::Group do
  let(:action1) { FactoryBot.build(:brexit_checker_action, id: "S01", grouping_criteria: %w[visiting-eu]) }
  let(:action2) { FactoryBot.build(:brexit_checker_action, id: "S02", grouping_criteria: %w[living-ie]) }
  let(:action3) { FactoryBot.build(:brexit_checker_action, id: "S03", grouping_criteria: %w[living-ie]) }
  let(:group1) { FactoryBot.build(:brexit_checker_group, key: "visiting-eu") }
  let(:group2) { FactoryBot.build(:brexit_checker_group, key: "living-ie") }
  let(:group3) { FactoryBot.build(:brexit_checker_group, key: "studying-uk") }

  describe "validations" do
    let(:group_with_invalid_key) { FactoryBot.build(:brexit_checker_group, key: "studying-mars") }

    it "validates citizen groups by key" do
      message = "Validation failed: Key is not included in the list"
      expect { group_with_invalid_key.valid? }.to raise_error(ActiveModel::ValidationError, message)
    end
  end

  describe "factories" do
    it "has a valid default factory" do
      group = FactoryBot.build(:brexit_checker_group)
      expect(group.valid?).to be(true)
    end
  end

  describe ".find_all" do
    before :each do
      allow(described_class).to receive(:load_all).and_return([group1, group2, group3])
    end

    it "returns a group by key" do
      expect(described_class.find_by("living-ie")).to eq group2
    end
  end

  describe "#hash & #eql?" do
    let(:group1) { FactoryBot.build(:brexit_checker_group, key: "visiting-eu") }
    let(:group2) { FactoryBot.build(:brexit_checker_group, key: "visiting-eu") }
    let(:group3) { FactoryBot.build(:brexit_checker_group, key: "living-uk") }

    it "correctly removes duplicates from an array by key" do
      expect([group1, group2, group3].uniq.map(&:key)).to eq(%w[visiting-eu living-uk])
    end
  end

  describe "#actions" do
    before :each do
      allow(BrexitChecker::Action).to receive(:load_all).and_return([action1, action2, action3])
    end

    it "retuns an action when a grouping_criteria matches the group key" do
      expect(group1.actions).to match_array([action1])
    end

    it "retuns multiple actions when multiple grouping_criteria match the group key" do
      expect(group2.actions).to match_array([action2, action3])
    end

    it "retuns an empty array when no action's grouping_criteria match the group key" do
      expect(group3.actions).to match_array([])
    end
  end

  describe "live actions" do
    it "ensure that actions.yaml contains valid groupings" do
      configured_groupings = BrexitChecker::Action.load_all.select { |action| action.grouping_criteria.present? }.flat_map{ |a| a.grouping_criteria }.sort.uniq
      expected_groupings = BrexitChecker::Validators::GroupValidator::CITIZEN_KEYS

      expect(configured_groupings).to match_array(expected_groupings)
    end
  end
end
