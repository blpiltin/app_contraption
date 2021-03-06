require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "not signed in" do
    let(:user) { FactoryGirl.create(:user) }

    it { should_not have_link('Profile', href: user_path(user)) }
    it { should_not have_link('Settings', href: edit_user_path(user)) }
  end

  describe "signin page" do
    before { visit signin_path }

    it { should have_heading('Sign In') }
    it { should have_title('Sign In') }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign In" }

      it { should have_title('Sign In') }
      it { should have_error_message('Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end

    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      let(:gadget) { FactoryGirl.create(:gadget, user: user)}
      before { sign_in(user) }

      it { should have_title('Gadgets') }
      it { should have_link('Menu', href: gadget_path(gadget)) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign Out', href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }

      describe "visiting the new user page" do
        before { visit new_user_path }
        it { should_not have_title(full_title('Sign Up')) }
      end

      describe "submitting a POST request to the Users#create action" do
        before { post '/users', { name: 'New User', email: 'new@user.com' } }
        specify { response.should redirect_to(root_path) }
      end

    end

    describe "as an admin user" do
      let(:user) { FactoryGirl.create(:user, admin:true) }
      before { sign_in(user) }

      it { should have_title('Users') }
      it { should have_link('Users',    href: root_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign Out', href: signout_path) }
      it { should_not have_link('Sign In', href: signin_path) }

      describe "visiting the new user page" do
        before { visit new_user_path }
        it { should have_title(full_title('New User')) }
        it { should_not have_title(full_title('Sign Up')) }
      end

      describe "submitting a POST request to the Users#create action" do
        before { post '/users', { name: 'New User', email: 'new@user.com' } }
        specify { response.should_not redirect_to(root_path) }
      end

    end

  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign In') }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign In') }
        end

      end

      describe "when attempting to visit a protected page" do

        before do
          visit edit_user_path(user)
          sign_in user
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_title(full_title('Update Your Profile'))
          end

          describe "when signing in again" do
            before do
              delete signout_path
              sign_in user
            end

            it "should render the default page" do
              page.should have_title(full_title('Gadgets'))
            end
          end

        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { response.should redirect_to(signin_path) }
        end
        
      end
      
      describe "in the Relationships controller" do
        describe "submitting to the create action" do
          before { post relationships_path }
          specify { response.should redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete relationship_path(1) }
          specify { response.should redirect_to(signin_path) }          
        end
      end

    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_title(full_title('Edit User')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }
      end

    end

    describe "as an admin user" do
      let(:admin) { FactoryGirl.create(:user, admin: true) }

      before { sign_in admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(admin) }
        specify { response.should redirect_to(users_path) }
      end

    end

  end

end
