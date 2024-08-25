RSpec.describe Trackstamps::Reborn do
  it "changing defaults is reflected in itself" do
    Trackstamps::Reborn.config.user_class_name = "Account"
    expect(Trackstamps::Reborn[:default].config.user_class_name).to eq("Account")
  end

  it "changing another does not interfere with user class name" do
    Trackstamps::Reborn.config.user_class_name = "Default"
    Trackstamps::Reborn[:alternative].config.user_class_name = "Alternative"

    expect(Trackstamps::Reborn[:default].config.user_class_name).to eq("Default")
    expect(Trackstamps::Reborn[:alternative].config.user_class_name).to eq("Alternative")
  end

  it "changing another does not interfere with updater foreign key" do
    Trackstamps::Reborn.config.updater_foreign_key = "updater_default_id"
    Trackstamps::Reborn[:alternative].config.updater_foreign_key = "updater_alternative_id"

    expect(Trackstamps::Reborn[:default].config.updater_foreign_key).to eq("updater_default_id")
    expect(Trackstamps::Reborn[:alternative].config.updater_foreign_key).to eq("updater_alternative_id")
  end

  it "changing another does not interfere with creator foreign key" do
    Trackstamps::Reborn.config.creator_foreign_key = "creator_default_id"
    Trackstamps::Reborn[:alternative].config.creator_foreign_key = "creator_alternative_id"

    expect(Trackstamps::Reborn[:default].config.creator_foreign_key).to eq("creator_default_id")
    expect(Trackstamps::Reborn[:alternative].config.creator_foreign_key).to eq("creator_alternative_id")
  end

  it "changing another does not interfere with get current user proc" do
    Trackstamps::Reborn.config.get_current_user = -> { "default" }
    Trackstamps::Reborn[:alternative].config.get_current_user = -> { "alternative" }

    expect(Trackstamps::Reborn[:default].config.get_current_user.call).to eq("default")
    expect(Trackstamps::Reborn[:alternative].config.get_current_user.call).to eq("alternative")
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
end
