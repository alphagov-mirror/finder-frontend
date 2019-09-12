require "spec_helper"

describe BrexitCheckerHelper, type: :helper do
  describe "#filter_items" do
    it "filters actions that should be shown" do
      action1 = instance_double BrexitChecker::Action, show?: true
      action2 = instance_double BrexitChecker::Action, show?: false
      expect(action1).to receive(:show?).with([])
      expect(action2).to receive(:show?).with([])
      results = filter_items([action1, action2], [])
      expect(results).to eq([action1])
    end

    it "filters options that should be shown" do
      option1 = instance_double BrexitChecker::Question::Option, show?: true
      option2 = instance_double BrexitChecker::Question::Option, show?: false
      expect(option1).to receive(:show?).with([])
      expect(option2).to receive(:show?).with([])
      results = filter_items([option1, option2], [])
      expect(results).to eq([option1])
    end
  end

  describe "#format_action_audiences" do
    let(:action1) { FactoryBot.build(:brexit_checker_action, audience: "citizen", priority: 5) }
    let(:action2) { FactoryBot.build(:brexit_checker_action, audience: "citizen", priority: 8) }
    let(:action3) { FactoryBot.build(:brexit_checker_action, audience: "business", priority: 5) }
    let(:action4) { FactoryBot.build(:brexit_checker_action, audience: "business", priority: 5) }

    subject { format_action_audiences(actions) }

    context "when there are actions for each audience" do
      let(:actions) { [action1, action2, action3, action4] }

      it "return actions grouped by audience and sorted by priority" do
        expect(subject).to eq([
          {
            heading: I18n.t("brexit_checker.results.audiences.citizen.heading"),
            actions: [action2, action1]
          },
          {
            heading: I18n.t("brexit_checker.results.audiences.business.heading"),
            actions: [action3, action4]
          }
        ])
      end
    end
  end

  describe "#persistent_criteria_keys" do
    let(:criteria_keys) { %w[A B C D] }
    let(:question_criteria_keys) { %w[C D] }

    subject { persistent_criteria_keys(question_criteria_keys) }

    it "returns all but the questions criteria" do
      expect(subject).to contain_exactly("A", "B")
    end
  end
end
