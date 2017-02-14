class ProjectsController < ApplicationController

  get '/projects' do
    if logged_in?
      @projects = current_user.projects.order(:due_date)
      erb :'/projects/index.html'
    else
    end
  end

  get '/projects/new' do
    if logged_in?
      @user = User.find_by(id: session[:user_id])
      erb :'/projects/new.html'
    else
      flash[:notice] = 'Please log in first to create a project.'
      reidirect 'login'
    end
  end

  post '/projects' do
    project = Project.create(params[:project])
    if project.save
      project.update(user_id: current_user.id)
      redirect "/projects/#{project.id}"
    else
      flash[:notice] = project.errors.full_messages.uniq.join(', ')
      redirect '/projects/new'
    end
  end

  get '/projects/:id' do
    @project = Project.find_by_id(params[:id])
    erb :'/projects/show.html'
  end

  get '/projects/:id/edit' do
    if logged_in?
      @project = Project.find_by(id: params[:id])
      if @project.user_id == current_user.id
        redirect to "/projects/#{@project.id}"
      else
        flash[:notice] = 'You can only edit your own projects.'
        redirect to "/projects/#{@project.id}"
      end
    else
      flash[:notice] = 'Please log in first to view projects.'
      redirect to '/login'
    end
  end

  patch '/projects/:id' do
    @project = Project.find_by_id(params[:id])
    @project.update(params[:project])
    if @project.save
      redirect to "/projects/#{@project.id}"
    else
      flash[:notice] = @project.errors.full_messages.uniq.join(', ')
      @project = Project.find_by_id(params[:id])
      redirect to "/projects/#{@project.id}/edit"
    end
  end

  # DELETE: /projects/5/delete
  delete '/projects/:id/delete' do
    raise session.inspect
    redirect '/projects'
  end
end
