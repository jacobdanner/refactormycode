require 'spec_helper'

describe Code do
  it { should respond_to(:user_name) }
  it { should respond_to(:user_email) }

  context "with a valid code" do
    let(:code) {Factory :code}

    it "delegates user_name to associated user" do
      code.user_name.should eq(code.user.name)
    end

    it "delegates user_email to associated user if user's email present" do
      code.user.email = Faker::Internet.email
      code.save
      code.user_email.should eq(code.user.email)
    end

    it "use default email if user's email blank" do
      code.user_email.should eq("no-email@refactormycode.com")
    end

    it "creates notification after_save" do
      code = Code.new Factory.attributes_for(:code).merge(:notify_me => '1')
      code.user = Factory :user, :email => Faker::Internet.email
      expect{code.save}.to change{Notification.count}.by(1)
    end
  end

  context "validations" do
    let(:code) {Code.new Factory.attributes_for(:code)}

    context "email_if_notify_me" do
      it "does not validates user's email if notify_me not selected" do
        code.valid?
        code.errors[:user].size.should eq(0)
      end

      context "with a user" do
        let(:user) {Factory :user}

        it "passes validation if notify_me selected and user has an email" do
          user.update_attribute :email, Faker::Internet.email
          code.notify_me = '1'
          code.user = user
          code.valid?
          code.errors[:user].size.should eq(0)
        end

        it "cannot notify if users email not supplied" do
          code.notify_me = '1'
          code.user = user
          code.valid?
          code.errors[:user].size.should eq(1)
        end
      end
    end
  end
end
