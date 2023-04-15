RSpec.describe Trackstamps::Reborn do
  with_model :Account, scope: :all
  with_model :Order, scope: :all do
    table do |t|
      t.string :title, default: "Order title"
      t.integer :assigned_by_id, null: true
      t.integer :edited_by_id, null: true
    end

    model do
      Trackstamps::Reborn.config.user_class_name = 'Account'
      Trackstamps::Reborn.config.updater_foreign_key = 'edited_by_id'
      Trackstamps::Reborn.config.creator_foreign_key = 'assigned_by_id'
      include Trackstamps::Reborn
    end
  end

  context 'with users' do
    let! :user_one do
      Account.create!
    end

    let! :user_two do
      Account.create!
    end

    before do
      Trackstamps::Reborn::Current.user = user_one
    end

    describe 'updating' do
      let! :post do
        Order.create!
      end

      it 'another user updates post' do
        Trackstamps::Reborn::Current.user = user_two
        post.update!(title: 'Else')
        expect(post.updater).to eq(user_two)
      end

      it 'another user updates post but creator stays the same' do
        Trackstamps::Reborn::Current.user = user_two
        post.update!(title: 'Else')
        expect(post.creator).to eq(user_one)
      end
    end

    describe 'creation' do
      it 'assigns user' do
        post = Order.create!
        expect(post.creator).to eq(user_one)
      end

      it 'assigns only after saving' do
        post = Order.new
        expect(post.creator).to be_nil
        post.save!
        expect(post.creator).to eq(user_one)
      end
    end
  end

  context 'with no user created' do
    it 'no user assigned to creator' do
      post = Order.create!
      expect(post.creator).to be_nil
    end

    it 'no user assigned to updater' do
      post = Order.create!
      expect(post.updater).to be_nil
    end
  end

  context 'configuration' do
    it 'creator foreign key does not get reassigned' do
      Trackstamps::Reborn.config.creator_foreign_key = 'wrong_id'
      expect(Order.const_get(:UPDATER_FOREIGN_KEY)).to_not eq('wrong_id')
    end

    it 'updater foreign key does not get reassigned' do
      Trackstamps::Reborn.config.updater_foreign_key = 'wrong_id'
      expect(Order.const_get(:UPDATER_FOREIGN_KEY)).to_not eq('wrong_id')
    end
  end
end
