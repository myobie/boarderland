class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def require_access_token
    unless session[:access_token]
      redirect_to authorize_wunderlist_path
    end
  end

  def wunderlist
    Wunderlist.new(session[:access_token])
  end

  def info(list)
    json = wunderlist_lists.find { |remote_list| remote_list.id == list.wunderlist_id }
    uncompleted_tasks = wunderlist_uncompleted_tasks(list.wunderlist_id)
    completed_tasks = wunderlist_completed_tasks(list.wunderlist_id)
    people = get_people(list.id)
    Wunder::List.new(list: list,
                     json: json,
                     uncompleted_tasks: uncompleted_tasks,
                     completed_tasks: completed_tasks,
                     users: people)
  end

  def get_person(id)
    @all_people.detect { |user| user.id == id }
  end

  def get_people(list_id)
    users = wunderlist.get("v1/users", list_id: list_id)
    @all_people ||= []
    @all_people.concat(users) if users
    users
  end

  def wunderlist_lists
    @wunderlist_lists ||= wunderlist.get("v1/lists")
  end

  def wunderlist_uncompleted_tasks(list_id)
    @wunderlist_uncompleted_tasks ||= {}
    @wunderlist_uncompleted_tasks[list_id] ||= begin
      wunderlist.get("v1/tasks", list_id: list_id)
    end
  end

  def wunderlist_completed_tasks(list_id)
    # There is a problem where completed: true sends back all tasks + completed instead of only completed
    @wunderlist_completed_tasks ||= {}
    @wunderlist_completed_tasks[list_id] ||= begin
      wunderlist.get("v1/tasks", list_id: list_id, completed: true).select(&:completed_at)
    end
  end
end
