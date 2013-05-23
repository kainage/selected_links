# SelectedLinks

Adds a link helper to ActionView::Base to that adds a class of _selected_
to the link when matched to a pattern, usually a url.

## Installation

Add this line to your application's Gemfile:

    gem 'selected_links'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install selected_links

## Configuration

Usage is the same as link_to and takes 2 optional arguments ```:matcher``` and ```:source```.

The default source matches to ```request.path```. This can be overridden in an initializer

```ruby
SelectableLinks.setup do |config|
  config.default_source = 'request.url'
end
```

### Useage

To make this link have a class of _selected_ when the url is at the top level:

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

Without a matcher option and NOT in the block form, this will look for _about_ in the source:

```
<%= selectable_link_to 'ABOUT', about_url %>
```

You can, of course, add this to links with other clases on them:

```
<%= selectable_link_to 'ABOUT', about_url, :class => 'nav' %>
# => <a ... class="nav selected">ABOUT</a>
```

To override the source per link, just add a ```:source``` argument:

```
<%= selectable_link_to 'ABOUT', about_url, :source => request.url %>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
