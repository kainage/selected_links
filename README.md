# Selected Links

[![Build Status](https://travis-ci.org/kainage/selected_links.png)](https://travis-ci.org/kainage/selected_links)

Adds a link helper to ActionView::Base to that adds a class of _active_
to the link when matched to a pattern, usually a url.

## Installation

Add this line to your application's Gemfile:

    gem 'selected_links'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install selected_links

## Configuration

Usage is the same as link_to and takes 3 optional arguments ```:matcher```, ```:source``` and ```class_name```.

You can override the default behaviour in an initilizer file:

```ruby
SelectedLinks.setup do |config|
  # Change the global default source that the matcher looks to check against
  config.default_source = 'request.path'

  # Change the fallback behaviour to match against the name of the link if the matcher fails
  config.fallback_to_name = false

  # Set the global default class name that is added to the link when a match is found
  config.default_class_name = 'active'
end
```

### Usage

To make this link have a class of _active_ when the url is at the top level:

```
<%= selectable_link_to 'Home', root_url, :matcher => '\/\z' %>
```

To make the link selected when the url has _topic_ anywhere in it:

```
<%= selectable_link_to 'Topics', topics_url, :matcher => 'topic' %>
```

Blocks still work and this will do the same thing as the previous example:

```
<% selectable_link_to community_url, :matcher => 'topic' do %>
  <%= content_tag :span, 'Community', :class => 'foo' %>
<% end %>
```

Without a matcher option and NOT in the block form, this will look for _about_
in the source if the option ```fallback_to_name``` is ```true```:

```
<%= selectable_link_to 'ABOUT', about_url %>
```

You can, of course, add this to links with other clases on them:

```
<%= selectable_link_to 'ABOUT', about_url, :class => 'nav' %>
# => <a ... class="nav avtive">ABOUT</a>
```

To override the source per link, just add a ```:source``` argument:

```
<%= selectable_link_to 'ABOUT', about_url, :source => request.url %>
```

To override the default class name added per link add ```:class_name``` argument:

```
<%= selectable_link_to 'ABOUT', about_url, :class_name => 'highlight' %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
