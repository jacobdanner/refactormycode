require 'spec_helper'

describe Code do
  let(:code) {Factory :code}

  it { should respond_to(:user_name) }

  it "delegates user_name to associated user" do
    code.user_name.should eq(code.user.name)
  end

  it "creates notification after_save" do
    code = Code.new Factory.attributes_for(:code).merge(:notify_me => '1')
    code.user = Factory :user
    expect{code.save}.to change{Notification.count}.by(1)
  end
end
