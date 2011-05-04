require 'spec_helper'

describe "Layout links" do
  it "should have a Home page at '/'" do
    get '/'
    response.should render_template('pages/home')
  end

  it "should have a signup page at '/signup'" do
    get '/signup'
    response.should render_template('users/new')
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "Home"
    response.should render_template('pages/home')
    click_link "Sign up now!"
    response.should render_template('users/new')
  end
end
