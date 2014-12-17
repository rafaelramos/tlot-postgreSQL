class DatabaseController < ApplicationController
  #TODO: Change basic authentication to the environment
  http_basic_authenticate_with name: "developers", password: "Crowd1122"

  def index
    @databases = ActiveRecord::Base.connection.execute("SELECT d.datname as \"Name\" FROM pg_catalog.pg_database d ORDER BY 1")
    @databases = @databases.values()
  end

  def create
    dbname = params[:name]
    begin
      ActiveRecord::Base.connection.execute("CREATE DATABASE #{dbname}")
    rescue ActiveRecord::StatementInvalid => e
      if e.to_s.include?('DuplicateDatabase')
        flash[:notice] = 'Database already exist'
      else
        flash[:notice] = 'Something went wrong'
      end
    rescue
      flash[:notice] = 'Something went wrong'
    end

    redirect_to root_url
  end

  def delete
    dbname = params[:name]
    begin
      ActiveRecord::Base.connection.execute("DROP DATABASE IF EXISTS #{dbname}")
    rescue
      flash[:notice] = 'Something went wrong'
    end

    redirect_to root_url
  end
end