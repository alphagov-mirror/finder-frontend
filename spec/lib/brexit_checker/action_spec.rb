require "spec_helper"

describe BrexitChecker::Action, :type => :model do
  describe "#flattened_criteria" do
    it "should return string criteria as an array with one string" do
      action = FactoryBot.build(:brexit_checker_action, criteria: "aero-space")
      expect(action.flattened_criteria).to eq(["aero-space"])
    end

    it "should flatten an any_of criteria hash into an array" do
      any_of_criteria = {"any_of"=>["environment", "import-from-eu", "export-from-eu"]}
      action = FactoryBot.build(:brexit_checker_action, criteria: any_of_criteria)
      expect(action.flattened_criteria).to eq(["environment", "import-from-eu", "export-from-eu"])
    end

    it "should flatten an all_of criteria hash into an array" do
      all_of_criteria = {"all_of"=>["nationality-eu", "working-uk"]}
      action = FactoryBot.build(:brexit_checker_action, criteria: all_of_criteria)
      expect(action.flattened_criteria).to eq(["nationality-eu", "working-uk"])
    end

    it "should flatten all_of and any_of critera hashes" do
      hybrid_criteria = {"all_of"=>["nationality-uk", {"any_of"=>["visiting-eu", "travel-eu-business"]}]}
      action = FactoryBot.build(:brexit_checker_action, criteria: hybrid_criteria)
      expect(action.flattened_criteria).to eq(["nationality-uk", "visiting-eu", "travel-eu-business"])
    end
  end

  describe "#show?" do
    it "should return true if the provided critera matches the action's criteria" do
      action = FactoryBot.build(:brexit_checker_action, criteria: "aero-space")
      expect(action.show?("aero-space")).to eq(true)
    end
    it "should return false if the provided critera does not match the action's criteria" do
      action = FactoryBot.build(:brexit_checker_action, criteria: "aero-space")
      expect(action.show?("forestry")).to eq(false)
    end
  end
end