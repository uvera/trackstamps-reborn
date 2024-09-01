RSpec.describe Trackstamps::Reborn do
  describe "changing defaults is reflected in itself" do
    before do
      Trackstamps::Reborn.config.user_class_name = "Account"
    end

    it "is reflected" do
      expect(Trackstamps::Reborn[:default].config.user_class_name).to eq("Account")
    end
  end

  describe "changing another does not interfere with user class name" do
    before do
      Trackstamps::Reborn.config.user_class_name = "Default"
      Trackstamps::Reborn[:alternative].config.user_class_name = "Alternative"
    end

    it "default is fine" do
      expect(Trackstamps::Reborn[:default].config.user_class_name).to eq("Default")
    end

    it "alternative is fine" do
      expect(Trackstamps::Reborn[:alternative].config.user_class_name).to eq("Alternative")
    end
  end

  describe "changing another does not interfere with updater foreign key" do
    before do
      Trackstamps::Reborn.config.updater_foreign_key = "updater_default_id"
      Trackstamps::Reborn[:alternative].config.updater_foreign_key = "updater_alternative_id"
    end

    it "default is fine" do
      expect(Trackstamps::Reborn[:default].config.updater_foreign_key).to eq("updater_default_id")
    end

    it "alternative is fine" do
      expect(Trackstamps::Reborn[:alternative].config.updater_foreign_key).to eq("updater_alternative_id")
    end
  end

  describe "changing another does not interfere with creator foreign key" do
    before do
      Trackstamps::Reborn.config.creator_foreign_key = "creator_default_id"
      Trackstamps::Reborn[:alternative].config.creator_foreign_key = "creator_alternative_id"
    end

    it "default is fine" do
      expect(Trackstamps::Reborn[:default].config.creator_foreign_key).to eq("creator_default_id")
    end

    it "alternative is fine" do
      expect(Trackstamps::Reborn[:alternative].config.creator_foreign_key).to eq("creator_alternative_id")
    end
  end

  describe "changing another does not interfere with get current user proc" do
    before do
      Trackstamps::Reborn.config.get_current_user = -> { "default" }
      Trackstamps::Reborn[:alternative].config.get_current_user = -> { "alternative" }
    end

    it "default is fine" do
      expect(Trackstamps::Reborn[:default].config.get_current_user.call).to eq("default")
    end

    it "alternative is fine" do
      expect(Trackstamps::Reborn[:alternative].config.get_current_user.call).to eq("alternative")
    end
  end

  it "instance is only created once" do
    instance_1 = Trackstamps::Reborn[:alternative]
    instance_2 = Trackstamps::Reborn[:alternative]

    expect(instance_1).to eq(instance_2)
  end

  it "different instances do not match" do
    instance_1 = Trackstamps::Reborn[:default]
    instance_2 = Trackstamps::Reborn[:alternative]

    expect(instance_1).not_to eq(instance_2)
  end

  it "inspect works properly" do
    instance = Trackstamps::Reborn[:inspected]
    expect(instance.inspect).to eq("Trackstamps::Reborn[:inspected]")
  end

  it "only constructs module once" do
    Trackstamps::Reborn[:once]
    module_count = Trackstamps::Base.instance_variable_get(:@mixins).keys.length
    Trackstamps::Reborn[:once]
    new_count = Trackstamps::Base.instance_variable_get(:@mixins).keys.length
    expect(module_count).to eq(new_count)
  end

  it "expect double index to return same module" do
    expect(Trackstamps::Reborn[:something][:something]).to eq(Trackstamps::Reborn[:something])
  end
end
