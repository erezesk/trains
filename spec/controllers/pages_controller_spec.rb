require 'spec_helper'

describe PagesController do
  integrate_views

  before(:each) do
    @base_title = "Trains | "
  end

  describe "GET 'home'" do
    it "should be successful" do
      get 'home'
      response.should be_success
    end

    it "should have the right title" do
      get 'home'
      response.should have_tag("title",
			       @base_title + "Home")
    end
  end
end
