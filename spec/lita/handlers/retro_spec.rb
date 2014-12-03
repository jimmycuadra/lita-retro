require "spec_helper"

describe Lita::Handlers::Retro, lita_handler: true do
  let(:bad_user) { Lita::User.create(2, name: "Bad User") }
  let(:neutral_user) { Lita::User.create(3, name: "Neutral User") }
  let(:retro_admin) do
    user = Lita::User.create(3, name: "Retro Admin")
    Lita::Authorization.new(registry.config).add_user_to_group!(user, :retro_admins)
    user
  end

  it { is_expected.to route_command("retro :) topic").to(:add_good) }
  it { is_expected.to route_command("retro :( topic").to(:add_bad) }
  it { is_expected.to route_command("retro :| topic").to(:add_neutral) }
  it { is_expected.to route_command("retro list").to(:list) }
  it { is_expected.to route_command("retro clear").with_authorization_for(:retro_admins).to(:clear) }

  it "adds good topics" do
    send_command("retro :) foo bar")
    send_command("retro list")
    expect(replies.last).to eq("Good topic from Test User: foo bar")
  end

  it "adds bad topics" do
    send_command("retro :( foo bar")
    send_command("retro list")
    expect(replies.last).to eq("Bad topic from Test User: foo bar")
  end

  it "adds neutral topics" do
    send_command("retro :| foo bar")
    send_command("retro list")
    expect(replies.last).to eq("Neutral topic from Test User: foo bar")
  end

  it "lists all topics" do
    send_command("retro :) something good!")
    send_command("retro :( something bad!", as: bad_user)
    send_command("retro :| something neutral!", as: neutral_user)
    send_command("retro list")
    expect(replies.last).to include("Good topic from Test User: something good!")
    expect(replies.last).to include("Bad topic from Bad User: something bad!")
    expect(replies.last).to include("Neutral topic from Neutral User: something neutral!")
  end

  it "clears all topics" do
    send_command("retro :) something good!")
    send_command("retro :( something bad!", as: bad_user)
    send_command("retro :| something neutral!", as: neutral_user)
    send_command("retro clear", as: retro_admin)
    send_command("retro list")
    expect(replies.last).to eq("There are no retrospective topics yet.")
  end
end
