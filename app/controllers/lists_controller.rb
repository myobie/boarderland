class ListsController < ApplicationController
  before_action :require_access_token

  def index
    Rails.logger.warn("Chad about to get wunderlist_lists")
    list_ids = wunderlist_lists.map(&:id)
    db_lists = List.where(wunderlist_id: list_ids)

    @lists = db_lists.each_with_object([]) do |list, arr|
      arr << info(list)
    end

    if @lists.empty?
      redirect_to new_list_path
    else
      render
    end
  end

  def new
    list_ids = wunderlist_lists.map(&:id)
    db_list_ids = List.where(wunderlist_id: list_ids).pluck(:wunderlist_id)
    @lists = wunderlist_lists.reject do |remote_list|
      db_list_ids.include?(remote_list.id)
    end.map { |json| Wunder::List.new(json: json) }
    render
  end

  def add
    list_ids = params[:lists].map(&:to_i)
    List.transaction do
      list_ids.each do |id|
        List.create! wunderlist_id: id
      end
    end
    redirect_to lists_path
  end

  def show
    @list = info(List.find(params[:id]))
    render
  end

  def remove
    List.find(params[:id]).destroy!
    redirect_to lists_path
  end

  private

  def wunderlist_lists
    @wunderlist_lists ||= wunderlist.get("v1/lists")
  end

  def wunderlist_uncompleted_tasks(list_id)
    wunderlist.get("v1/tasks", list_id: list_id)
  end

  def wunderlist_completed_tasks(list_id)
    # There is a problem where completed: true sends back all tasks + completed instead of only completed
    wunderlist.get("v1/tasks", list_id: list_id, completed: true).select(&:completed_at)
  end

  def info(list)
    Rails.logger.warn("Chad: #{list.inspect}")
    json = wunderlist_lists.find { |remote_list| remote_list.id == list.wunderlist_id }
    uncompleted_tasks = wunderlist_uncompleted_tasks(list.wunderlist_id)
    completed_tasks = wunderlist_completed_tasks(list.wunderlist_id)
    Wunder::List.new(list: list,
                     json: json,
                     uncompleted_tasks: uncompleted_tasks,
                     completed_tasks: completed_tasks)
  end
end
