describe SessionsController, :omniauth do

  before do
    request.env['omniauth.auth'] = auth_mock
  end

  describe '#create' do

    it 'creates a user' do
      expect {post :create, provider: :google_oauth2}.to change{ User.count }.by(1)
    end

    it 'creates a session' do
      expect(session[:user_id]).to be_nil
      post :create, provider: :google_oauth2
      expect(session[:user_id]).not_to be_nil
    end

    it 'redirects to the users page' do
      post :create, provider: :google_oauth2
      expect(response).to redirect_to user_path(session[:user_id])
    end
  end

  describe '#destroy' do

    before do
      post :create, provider: :google_oauth2
    end

    it 'resets the session' do
      expect(session[:user_id]).not_to be_nil
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to the home page' do
      delete :destroy
      expect(response).to redirect_to root_url
    end
  end
end
