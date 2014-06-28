require 'spec_helper'

RSpec.describe App, :type => :model do
  before(:each) do
    @a = create(:user)
    @b = create(:user)
    @c = create(:user)

    @x = App.create appid: 1
    @y = App.create appid: 2
    @z = App.create appid: 3
  end
  describe "#save_top_list" do

    it "should add apps to user list" do
      expect{
        @b.save_top_list [@x, @y, @z]
      }.to change{@b.reload.top_10_apps.size}.by(3)
      @b.top_10_apps.should be_include @x
    end

    it "should add users to app" do
      expect{
        @a.save_top_list [@x, @y, @z]
        @b.save_top_list [@x, @y, @z]
        @c.save_top_list [@x, @y, @z]
      }.to change{@x.reload.collectors.size}.by(3)
    end
  end

  describe "#save_apps" do
    it "should replace with new apps" do
      @a.apps = [@z]
      expect{
        @a.save_apps [@x, @y]
      }.to change{ @a.reload.apps.size }.to(2)

      @a.apps.should_not be_include(@z)
    end
  end

  describe "#info" do
    it "should request remote data" do
      app = App.create appid: 350962117
      app.info.should_not be_empty
    end
  end
end
