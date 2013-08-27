module SelectedLinks
  class Railtie < Rails::Railtie
    initializer 'selected_links.action_view_extension' do
      ActiveSupport.on_load :action_view do
        include ActionView
      end
    end
  end
end