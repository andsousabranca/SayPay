module ApplicationHelper
  def render_markdown(text)
    Kramdown::Document.new(text, input: 'GFM', syntax_highlighter: "rouge").to_html
  end

  def show_nav_and_header?
    !(controller_name == "pages" && action_name == "home")
  end
end
