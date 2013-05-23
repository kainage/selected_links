require "selected_links/version"
require 'selected_links/link'
require 'selected_links/action_view'

if defined? Rails
	require 'selected_links/railtie'
else
	ActionView::Base.send(:include, SelectedLinks::ActionView)
end

module SelectedLinks
	mattr_accessor :default_source
	@@default_source = 'request.path'

	def self.setup
		yield self
	end
end