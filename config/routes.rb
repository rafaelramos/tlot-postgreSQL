TlotPostgresql::Application.routes.draw do
  namespace 'database' do
    get 'index'
    post 'create'
    post 'delete'
  end

  root to: 'database#index'
end
