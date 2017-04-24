require 'rails_helper'

RSpec.describe "wikis/new", type: :view do
  before(:each) do
    assign(:wiki, Wiki.new())
  end

  it "renders new wiki form" do
    render

    assert_select "form[action=?][method=?]", wikis_path, "post" do
    end
  end
end
