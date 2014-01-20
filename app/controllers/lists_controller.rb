class ListsController < ApplicationController
  before_action :require_access_token

  def index
    list_ids = wunderlist_lists.map(&:id)
    db_lists = List.where(wunderlist_id: list_ids)

    @lists = db_lists.each_with_object([]) do |list, arr|
      arr << info(list)
    end.sort {|x,y| x.title <=> y.title}

    render
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
    list = List.find(params[:id])
    @list = info(list)
    render
  end

  def by_wunderlist_id
    @list = info(List.find_by_wunderlist_id(params[:id]))
    render :show
  end

  def destroy
    List.find(params[:id]).destroy!
    redirect_to lists_path
  end
end
