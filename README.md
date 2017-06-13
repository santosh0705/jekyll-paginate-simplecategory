# Jekyll::Paginate::Simplecategory

Simple Pagination Generator for Jekyll Posts Categories


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-paginate-simplecategory'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-paginate-simplecategory


## Usage

### Config Example

Example of `_config.yml` file:

```yaml
# Plugins
gems:
  - jekyll-paginate
  - jekyll-paginate-simplecategory

# Pagination
paginate: 5
paginate_path: "/blog/page:num"

category_paginate_path: "/blog/:categories/page:num"
```

### Customization

#### Layout

Simplecategory uses the default layout template set for pagination configured in the `paginate_path` parameter. To change the default layout add the `category_layout` parameter in `_config.yml` file:

```yaml
# Pagination
category_layout: "category.html"
```

Create the layout file `category.html` in `_layout` directory. If you are placing the layout file in any other directory than put the relative path of the file as below.

```yaml
# Pagination
category_layout: "/my_layouts/category.html"
```

#### Other

You can set a custom title for each pages by adding the `category_page_title` parameter in `_config.yml` file:

```yaml
# Pagination
category_page_title: "My Blog - :categories - Page:num"
```


## Contributing

Feel free to report any bug and/or submit any improvement pull requests.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

