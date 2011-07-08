require 'spec_helper'

describe User do
  let(:user) {Factory :user}
  let(:user1) {Factory :user}
  let(:user2) {Factory :user}

  it "should get 2 user's fans" do
    Factory.create :friendship, :user => user1 ,:friend => user
    Factory.create :friendship, :user => user2, :friend => user
    user.fans.should have(2).records
  end

  it "should get a token after doing create_token!" do
    token = user.create_token!
    user.token.should == token
  end

  it "should return the right position" do
    user.update_attributes(:rating => 1, :refactors_count => 1)
    user1.update_attributes(:rating => 3, :refactors_count => 3)
    user2.update_attributes(:rating => 5, :refactors_count => 5)
    user.position.should == 1
    user1.position.should == 2
    user2.position.should == 3
  end

end