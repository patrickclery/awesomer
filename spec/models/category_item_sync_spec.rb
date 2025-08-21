# frozen_string_literal: true

require "rails_helper"

RSpec.describe CategoryItem, "sync methods" do
  describe "#star_delta" do
    context "when both stars and previous_stars are present" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 150) }

      it "returns the difference" do
        expect(item.star_delta).to eq(50)
      end
    end

    context "when stars decreased" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 80) }

      it "returns a negative difference" do
        expect(item.star_delta).to eq(-20)
      end
    end

    context "when stars is nil" do
      let(:item) { build(:category_item, previous_stars: 100, stars: nil) }

      it "returns 0" do
        expect(item.star_delta).to eq(0)
      end
    end

    context "when previous_stars is nil" do
      let(:item) { build(:category_item, previous_stars: nil, stars: 100) }

      it "returns 0" do
        expect(item.star_delta).to eq(0)
      end
    end

    context "when both are nil" do
      let(:item) { build(:category_item, previous_stars: nil, stars: nil) }

      it "returns 0" do
        expect(item.star_delta).to eq(0)
      end
    end

    context "when stars equal previous_stars" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 100) }

      it "returns 0" do
        expect(item.star_delta).to eq(0)
      end
    end
  end

  describe "#needs_update?" do
    context "when delta exceeds threshold" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 150) }

      it "returns true with default threshold" do
        expect(item.needs_update?).to be(true)
      end

      it "returns false with higher threshold" do
        expect(item.needs_update?(100)).to be(false)
      end
    end

    context "when delta is negative and exceeds threshold" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 50) }

      it "returns true (uses absolute value)" do
        expect(item.needs_update?).to be(true)
      end
    end

    context "when delta equals threshold" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 110) }

      it "returns true" do
        expect(item.needs_update?(10)).to be(true)
      end
    end

    context "when delta is below threshold" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 105) }

      it "returns false" do
        expect(item.needs_update?(10)).to be(false)
      end
    end

    context "when previous_stars is nil but stars is present" do
      let(:item) { build(:category_item, previous_stars: nil, stars: 100) }

      it "returns true (new item)" do
        expect(item.needs_update?).to be(true)
      end
    end

    context "when stars is nil" do
      let(:item) { build(:category_item, previous_stars: 100, stars: nil) }

      it "returns false" do
        expect(item.needs_update?).to be(false)
      end
    end

    context "when both are nil" do
      let(:item) { build(:category_item, previous_stars: nil, stars: nil) }

      it "returns false" do
        expect(item.needs_update?).to be(false)
      end
    end

    context "with custom threshold" do
      let(:item) { build(:category_item, previous_stars: 100, stars: 103) }

      it "uses the provided threshold" do
        expect(item.needs_update?(2)).to be(true)
        expect(item.needs_update?(5)).to be(false)
      end
    end
  end

  describe "#update_previous_stars!" do
    let(:item) { create(:category_item, previous_stars: 100, stars: 150) }

    it "sets previous_stars to current stars value" do
      item.update_previous_stars!
      expect(item.reload.previous_stars).to eq(150)
    end

    context "when stars is nil" do
      let(:item) { create(:category_item, previous_stars: 100, stars: nil) }

      it "sets previous_stars to nil" do
        item.update_previous_stars!
        expect(item.reload.previous_stars).to be_nil
      end
    end

    context "when stars is 0" do
      let(:item) { create(:category_item, previous_stars: 100, stars: 0) }

      it "sets previous_stars to 0" do
        item.update_previous_stars!
        expect(item.reload.previous_stars).to eq(0)
      end
    end
  end

  describe ".needing_update scope" do
    let!(:needs_update_positive) { create(:category_item, previous_stars: 100, stars: 150) }
    let!(:needs_update_negative) { create(:category_item, previous_stars: 100, stars: 50) }
    let!(:needs_update_new) { create(:category_item, previous_stars: nil, stars: 100) }
    let!(:no_update_small_delta) { create(:category_item, previous_stars: 100, stars: 105) }
    let!(:no_update_no_stars) { create(:category_item, previous_stars: 100, stars: nil) }

    context "with default threshold" do
      it "includes items with large positive deltas" do
        expect(described_class.needing_update).to include(needs_update_positive)
      end

      it "includes items with large negative deltas" do
        expect(described_class.needing_update).to include(needs_update_negative)
      end

      it "includes new items with stars" do
        expect(described_class.needing_update).to include(needs_update_new)
      end

      it "excludes items with small deltas" do
        expect(described_class.needing_update).not_to include(no_update_small_delta)
      end

      it "excludes items without stars" do
        expect(described_class.needing_update).not_to include(no_update_no_stars)
      end
    end

    context "with custom threshold" do
      it "applies the custom threshold" do
        results = described_class.needing_update(3)
        expect(results).to include(needs_update_positive, needs_update_negative, needs_update_new,
no_update_small_delta)
        expect(results).not_to include(no_update_no_stars)
      end
    end
  end
end
