require 'action_view'

module SelectedLinks
  # Usage is the same as link_to and takes an optional regex argument matcher.
  #
  #   <%= selectable_link_to 'Home', root_url, :matcher => '\/\z' %>
  #
  # That would make this link have a class of 'selected' when the url is at the top level.
  #
  #   <%= selectable_link_to 'Topics', topics_url, :matcher => 'topic' %>
  #
  # This will make the nav link selected when the url has 'topic' in it anywhere.
  #
  #   <% selectable_link_to community_url, :matcher => 'topic' do %>
  #     <%= content_tag :span, 'Community', :class => 'foo' %>
  #   <% end %>
  #
  # Blocks still work and this will do the same thing as the previous example.
  #
  #  <%= selectable_link_to 'ABOUT', about_url %>
  #
  # Without a matcher option and NOT in the block form, this will look for 'about' in the url.
  module ActionView
    def selectable_link_to(*args, &block)
      link = Link.new(*args, &block).generate

      # Add default source if none was given.
      unless link.source
        link.source = instance_eval(SelectedLinks.default_source)
        # Can run generate again because there will for sure be no match here yet.
        link.generate
      end

      if block_given?
        raw link_to link.options, link.html_options, &block
      else
        raw link_to link.name, link.options, link.html_options
      end
    end
  end
end
