RSpec.describe Trackstamps::Reborn do
  with_model :Account, scope: :all
  with_model :Order, scope: :all do
    table do |t|
      t.string :title, default: "record title"
      t.integer :assigned_by_id, null: true
      t.integer :edited_by_id, null: true
    end

    model do
      Trackstamps::Reborn.config.user_class_name = "Account"
      Trackstamps::Reborn.config.updater_foreign_key = "edited_by_id"
      Trackstamps::Reborn.config.creator_foreign_key = "assigned_by_id"
      include Trackstamps::Reborn
    end
  end

  context "with users" do
    let! :user_one do
      Account.create!
    end

    let! :user_two do
      Account.create!
    end

    before do
      described_class::Current.user = user_one
    end

    describe "updating" do
      let! :record do
        Order.create!
      end

      it "another user updates post" do
        described_class::Current.user = user_two
        record.update!(title: "Else")
        expect(record.updater).to eq(user_two)
      end

      it "another user updates the record but creator stays the same" do
        described_class::Current.user = user_two
        record.update!(title: "Else")
        expect(record.creator).to eq(user_one)
      end
    end

    describe "creation" do
      it "assigns user" do
        record = Order.create!
        expect(record.creator).to eq(user_one)
      end

      it "has no creator when new" do
        record = Order.new
        expect(record.creator).to be_nil
      end

      it "assigns only after saving" do
        record = Order.new
        record.save!
        expect(record.creator).to eq(user_one)
      end
    end
  end

  context "with no user created" do
    it "no user assigned to creator" do
      record = Order.create!
      expect(record.creator).to be_nil
    end

    it "no user assigned to updater" do
      record = Order.create!
      expect(record.updater).to be_nil
    end
  end

  context "with wrong foreign key" do
    it "creator foreign key does not get reassigned" do
      described_class.config.creator_foreign_key = "wrong_id"
      expect(Order.const_get(:UPDATER_FOREIGN_KEY)).not_to eq("wrong_id")
    end

    it "updater foreign key does not get reassigned" do
      described_class.config.updater_foreign_key = "wrong_id"
      expect(Order.const_get(:UPDATER_FOREIGN_KEY)).not_to eq("wrong_id")
    end
  end
end
