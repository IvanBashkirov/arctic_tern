require 'rails_helper'

RSpec.describe "wikis/edit", type: :view do
  before(:each) do
    @wiki = assign(:wiki, Wiki.create!())
  end

  it "renders the edit wiki form" do
    render

    assert_select "form[action=?][method=?]", wiki_path(@wiki), "post" do
    end
  end
end
