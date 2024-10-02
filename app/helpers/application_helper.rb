# app/helpers/application_helper.rb
module ApplicationHelper
  def status_classes(status)
    case status
    when 'not_started'
      'bg-red-200 text-red-800'
    when 'in_progress'
      'bg-yellow-200 text-yellow-800'
    when 'completed'
      'bg-green-200 text-green-800'
    when 'on_hold'
      'bg-blue-200 text-blue-800'
    else
      'bg-gray-200 text-gray-800'
    end
  end
end

