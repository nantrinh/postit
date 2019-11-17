module ApplicationHelper
  def fix_url(str)
    str.start_with?('http://', 'https://') ? str : "http://#{str}"
  end
end
