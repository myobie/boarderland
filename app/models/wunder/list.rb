require 'forwardable'

class Wunder::List
  include ActiveModel::Model
  attr_accessor :list, :json, :uncompleted_tasks, :completed_tasks, :users

  extend Forwardable

  delegate [:id] => :list
  delegate [:title] => :json

  def wunderlist_id
    if json
      json.id
    end
  end

  def assignee_ids
    all_tasks.map(&:assignee_id).compact.uniq
  end

  def assignee_names
    assignee_ids.map { |id| user_name(id) }
  end

  def user_name(id)
    user = users.detect { |u| assignee_ids.include?(u.id) } if users
    user.name if user
  end

  def ratio_of_completed_tasks
    if completed_tasks_count > 0 && tasks_count > 0
      (completed_tasks_count.to_f / tasks_count.to_f).round(3)
    else
      0.0
    end
  end

  def percent_complete
    (ratio_of_completed_tasks * 100).round
  end

  def all_tasks
    uncompleted_tasks + completed_tasks
  end

  def tasks_count
    uncompleted_tasks_count + completed_tasks_count
  end

  def uncompleted_tasks_count
    uncompleted_tasks.length
  end

  def completed_tasks_count
    completed_tasks.length
  end
end
