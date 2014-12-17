require 'spec_helper'

describe DatabaseController, type: :controller do
  let(:database_name) { 'spec_test' }

  describe '#index' do
    it 'renders the view' do
      get :index
      expect(response).to be_ok
    end

    it 'returns the databases' do
      get :index
      expect(assigns(:databases)).not_to be_empty
    end
  end

  describe '#new' do
    it 'creates a new database' do
      expect {
        post :create, { name: database_name }
      }.to change {
        ActiveRecord::Base.connection.execute("SELECT d.datname as \"Name\" FROM pg_catalog.pg_database d ORDER BY 1").values().length
      }.by 1
    end

    it 'returns error if the database already exist' do
      ActiveRecord::Base.connection.execute("CREATE DATABASE #{database_name}")

      post :create, { name: database_name }
      expect(flash[:notice]).to eql 'Database already exist'
    end

    it 'returns error if something went wrong' do
      post :create, { name: 'wrong name with space' }
      expect(flash[:notice]).to eql 'Something went wrong'
    end

    after(:each) do
      ActiveRecord::Base.connection.execute("DROP DATABASE IF EXISTS #{database_name}")
    end
  end

  describe '#delete' do
    before(:each) do
      ActiveRecord::Base.connection.execute("CREATE DATABASE #{database_name}")
    end

    it 'deletes the database' do
      expect {
        post :delete, { name: database_name }
      }.to change {
        ActiveRecord::Base.connection.execute("SELECT d.datname as \"Name\" FROM pg_catalog.pg_database d ORDER BY 1").values().length
      }.by -1
    end

    xit 'returns error if something went wrong' do
      #TODO: Mock error or find a way to produce one
    end

    after(:each) do
      ActiveRecord::Base.connection.execute("DROP DATABASE IF EXISTS #{database_name}")
    end
  end
end