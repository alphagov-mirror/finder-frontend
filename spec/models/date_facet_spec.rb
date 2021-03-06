require "spec_helper"

describe DateFacet do
  let(:facet_data) do
    {
      "type" => "date",
      "name" => "Occurred",
      "key" => "date_of_occurrence",
      "preposition" => "occurred",
    }
  end

  describe "#sentence_fragment" do
    context "single date value" do
      let(:value) { { from: "22/09/1988" } }
      subject { DateFacet.new(facet_data, value) }

      specify do
        expect(subject.sentence_fragment["preposition"]).to eql("occurred after")
        expect(subject.sentence_fragment["values"].first["label"]).to eql("22 September 1988")
        expect(subject.sentence_fragment["key"]).to eql("date_of_occurrence")
      end
    end

    context "6 digit date value" do
      let(:value) { { to: "22/09/14" } }
      subject { DateFacet.new(facet_data, value) }

      specify do
        expect(subject.sentence_fragment["preposition"]).to eql("occurred before")
        expect(subject.sentence_fragment["values"].first["label"]).to eql("22 September 2014")
        expect(subject.sentence_fragment["key"]).to eql("date_of_occurrence")
      end
    end

    context "multiple date values" do
      let(:value) do
        {
          "from" => "22/09/1988",
          "to" => "22/09/2014",
        }
      end
      subject { DateFacet.new(facet_data, value) }

      specify do
        expect(subject.sentence_fragment["preposition"]).to eql("occurred between")
        expect(subject.sentence_fragment["values"].first["label"]).to eql("22 September 1988")
        expect(subject.sentence_fragment["values"].last["label"]).to eql("22 September 2014")
        expect(subject.sentence_fragment["key"]).to eql("date_of_occurrence")
      end
    end
  end

  describe "#query_params" do
    context "multiple date values" do
      let(:value) do
        {
          "from" => "22/09/1988",
          "to" => "22/09/2014",
        }
      end
      subject { DateFacet.new(facet_data, value) }
      specify do
        expect(subject.query_params).to eql(
          "date_of_occurrence" =>
            { "from" => "22/09/1988",
              "to" => "22/09/2014" },
        )
      end
    end
  end
end
