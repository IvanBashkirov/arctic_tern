require 'rails_helper'

RSpec.describe "wikis/index", type: :view do
  before(:each) do
    assign(:wikis, [
      Wiki.create!(),
      Wiki.create!()
    ])
  end

  it "renders a list of wikis" do
    render
  end
end
