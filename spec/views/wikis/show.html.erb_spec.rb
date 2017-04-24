require 'rails_helper'

RSpec.describe "wikis/show", type: :view do
  before(:each) do
    @wiki = assign(:wiki, Wiki.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
