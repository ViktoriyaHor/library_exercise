module ApplicationHelper
  def uikit_class_for(name)
    {
        success: 'success',
        error: 'danger',
        danger: 'danger',
        alert: 'warning',
    }[name.to_sym] || name
  end
  def current_class?(test_path)
    return 'uk-active' if request.path == test_path
    ''
  end
end
