module ApplicationHelper
  def fix_url(str)
    str.start_with?('http://', 'https://') ? str : "http://#{str}"
  end

  def display_datetime(dt)
    if logged_in? && !current_user.time_zone.blank?
      dt = dt.in_time_zone(current_user.time_zone)
    end
    dt.strftime("%m/%d/%Y %l:%M%P %Z")
  end

  def restrict_newlines(text, n)
    text.count("\n") > n ? text.split("\n")[0..n].join("\n") + "..." : text
  end
end
