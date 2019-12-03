require "spec_helper"

describe BrexitChecker::ResultsAudiences do
  describe "#populate_citizen_groups" do
    let(:action1) { FactoryBot.build(:brexit_checker_action, :citizen) }
    let(:action2) { FactoryBot.build(:brexit_checker_action, :citizen) }
    let(:action3) { FactoryBot.build(:brexit_checker_action, :citizen) }
    let(:action4) { FactoryBot.build(:brexit_checker_action, :citizen) }
    let(:action5) { FactoryBot.build(:brexit_checker_action, :citizen) }
    let(:actions) { [action1, action2, action3, action4, action5] }
  end

  describe "#populate_business_groups" do
    let(:action1) { FactoryBot.build(:brexit_checker_action, :business, criteria: %w(owns-operates-business-organisation)) }
    let(:action2) { FactoryBot.build(:brexit_checker_action, :business, criteria: %w(aero-space)) }
    let(:action3) { FactoryBot.build(:brexit_checker_action, :business, criteria: %w(forestry)) }
    let(:selected_criteria) { %w(owns-operates-business-organisation aero-space forestry exports-enchanted-goods) }
    let(:actions) { [action1, action2, action3] }

    context "actions are provided but there are no criteria" do
      let(:result) { described_class.populate_business_groups(actions, []) }
      it "returns an empty array" do
        expect(result).to eq([])
      end
    end

    context "criteria are provided but there are no actions" do
      let(:result) { described_class.populate_business_groups([], selected_criteria) }
      it "returns an empty array" do
        expect(result).to eq([])
      end
    end

    context "actions and criteria are provided" do
      let(:result) { described_class.populate_business_groups(actions, selected_criteria) }
      it "produces an hash of actions and criteria" do
        expect(result).to eq(
          actions: actions,
          criteria: %w(owns-operates-business-organisation aero-space forestry),
        )
      end

      it "excludes answer criteria that are not relevant to actions" do
        expect(result[:criteria].length).to eq(3)
        expect(result[:criteria]).not_to include("exports-enchanted-goods")
        expect(result[:criteria]).to include("owns-operates-business-organisation")
        expect(result[:criteria]).to include("aero-space")
        expect(result[:criteria]).to include("forestry")
      end
    end
  end
end
