RSpec.describe Trackstamps::Reborn do
  with_model :User, scope: :all
  with_model :Post, scope: :all do
    table do |t|
      t.string :title, default: "Post title"
      t.integer :created_by_id, null: true
      t.integer :updated_by_id, null: true
    end

    model do
      Trackstamps::Reborn.reset_config
      include Trackstamps::Reborn
    end
  end

  context "with users" do
    let! :user_one do
      User.create!
    end

    let! :user_two do
      User.create!
    end

    before do
      described_class::Current.user = user_one
    end

    describe "updating" do
      let! :post do
        Post.create!
      end

      it "another user updates post" do
        described_class::Current.user = user_two
        post.update!(title: "Else")
        expect(post.updater).to eq(user_two)
      end

      it "another user updates post but creator stays the same" do
        described_class::Current.user = user_two
        post.update!(title: "Else")
        expect(post.creator).to eq(user_one)
      end
    end

    describe "creation" do
      it "assigns user" do
        post = Post.create!
        expect(post.creator).to eq(user_one)
      end

      it "has no creator when new" do
        post = Post.new
        expect(post.creator).to be_nil
      end

      it "assigns only after saving" do
        post = Post.new
        post.save!
        expect(post.creator).to eq(user_one)
      end
    end

    describe "other config does not interfere" do
      before do
        described_class::Current.user = user_two
        Trackstamps::Reborn[:alternative].config.get_current_user = -> {}
      end

      it "user is not nil" do
        post = Post.create!
        expect(post.creator).to eq(user_two)
      end

      it "calling module config method returns user two" do
        expect(Trackstamps::Reborn.config.get_current_user.call).to eq(user_two)
      end
    end
  end

  context "with no user created" do
    it "no user assigned to creator" do
      post = Post.create!
      expect(post.creator).to be_nil
    end

    it "no user assigned to updater" do
      post = Post.create!
      expect(post.updater).to be_nil
    end
  end

  describe "trackstamps instance methods are private" do
    it "cannot access trackstamps_module" do
      post = Post.create!
      expect { post.trackstamps_module }.to raise_error(NoMethodError)
    end

    it "cannot access trackstamps_current_user" do
      post = Post.create!
      expect { post.trackstamps_current_user }.to raise_error(NoMethodError)
    end
  end
end
