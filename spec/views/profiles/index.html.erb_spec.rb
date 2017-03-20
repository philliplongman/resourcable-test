require 'rails_helper'

RSpec.describe "profiles/index", type: :view do
  before(:each) do
    assign(:profiles, [
      Profile.create!(
        :display_name => "Display Name"
      ),
      Profile.create!(
        :display_name => "Display Name"
      )
    ])
  end

  it "renders a list of profiles" do
    render
    assert_select "tr>td", :text => "Display Name".to_s, :count => 2
  end
end
