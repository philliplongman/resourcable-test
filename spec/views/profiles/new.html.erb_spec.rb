require 'rails_helper'

RSpec.describe "profiles/new", type: :view do
  before(:each) do
    assign(:profile, Profile.new(
      :display_name => "MyString"
    ))
  end

  it "renders new profile form" do
    render

    assert_select "form[action=?][method=?]", profiles_path, "post" do

      assert_select "input#profile_display_name[name=?]", "profile[display_name]"
    end
  end
end
