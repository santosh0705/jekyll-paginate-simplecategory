require 'jekyll-paginate-simplecategory/version'

module Jekyll
  module Paginate
    module Simplecategory
      
      class Pagination < Generator
        safe true
        priority :lowest

        def generate(site)
          if CategoryPager.pagination_enabled?(site)
            paginate(site)
          end
        end

        # Paginates the blog's posts. Renders the index.html file into paginated
        # directories, e.g.: page2/index.html, page3/index.html, etc and adds more
        # site-wide data.
        #
        # site          - The Site.
        #
        # {"paginator" => { "page" => <Number>,
        #                   "per_page" => <Number>,
        #                   "posts" => [<Post>],
        #                   "total_posts" => <Number>,
        #                   "total_pages" => <Number>,
        #                   "previous_page" => <Number>,
        #                   "next_page" => <Number> }}
        def paginate(site)
          if category_layout = site.config['category_layout']
            template_name = File.basename(category_layout)
            template_dir = File.dirname(category_layout)
            template_dir = '/_layouts' if template_dir == '.'
            template_dir.prepend('/') unless template_dir.start_with? '/'
          else
            if template = template_page(site)
              template_name = template.name
              template_dir = template.dir
            else
              Jekyll.logger.warn "Pagination:", "Pagination is enabled, but I couldn't find " +
              "an index.html page to use as the pagination template. Skipping pagination."
            end
          end
          site.categories.each do |category, all_posts|
            all_posts = all_posts.reject { |p| p['hidden'] }
            pages = CategoryPager.calculate_pages(all_posts, site.config['paginate'].to_i)
            (1..pages).each do |num_page|
              paginate_path = CategoryPager.paginate_path(site, num_page, category)
              pager = CategoryPager.new(site, num_page, all_posts, pages, category)
              if page_title = site.config['category_page_title']
                page_title = page_title.sub(':categories', category.capitalize)
                page_title = page_title.sub(':num', num_page.to_s)
              end
              site.pages << CategoryPage.new(site, site.source, paginate_path, 'index.html', template_dir, template_name, pager, page_title)
            end
          end
        end

        # Find the Jekyll::Page which will act as the pager template
        #
        # site - the Jekyll::Site object
        #
        # Returns the Jekyll::Page which will act as the pager template
        def template_page(site)
          site.pages.dup.select do |page|
            CategoryPager.pagination_candidate?(site.config, page)
          end.sort do |one, two|
            two.path.size <=> one.path.size
          end.first
        end
      end

      class CategoryPage < Page
        def initialize(site, base, dir, name, template_dir, template_name, pager, page_title)
          @site = site
          @base = base
          @dir = dir
          @name = name
          @pager = pager

          self.process(@name)
          self.read_yaml(File.join(base, template_dir), template_name)
          self.data['title'] = page_title if page_title
        end
      end

      class CategoryPager < Paginate::Pager
        def initialize(site, page, all_posts, num_pages = nil, category)
          @page = page
          @per_page = site.config['paginate'].to_i
          @total_pages = num_pages || CategoryPager.calculate_pages(all_posts, @per_page)

          if @page > @total_pages
            raise RuntimeError, "page number can't be greater than total pages: #{@page} > #{@total_pages}"
          end

          init = (@page - 1) * @per_page
          offset = (init + @per_page - 1) >= all_posts.size ? all_posts.size : (init + @per_page - 1)

          @total_posts = all_posts.size
          @posts = all_posts[init..offset]
          @previous_page = @page != 1 ? @page - 1 : nil
          @previous_page_path = CategoryPager.paginate_path(site, @previous_page, category)
          @next_page = @page != @total_pages ? @page + 1 : nil
          @next_page_path = CategoryPager.paginate_path(site, @next_page, category)
        end

        # Return the pagination path of the page
        #
        # site     - the Jekyll::Site object
        # num_page - the pagination page number
        # category - the category name
        #
        # Returns the pagination path as a string
        def self.paginate_path(site, num_page, category)
          return nil if num_page.nil?
          path = site.config['category_paginate_path'] || '/blog/:categories/page:num'
          path = path.sub(':categories', category)
          path = path.sub(':num', num_page.to_s)
          path.prepend('/') unless path.start_with? '/'
          path_first = File.dirname(path)
          num_page <= 1 ? path_first : path
        end
      end

    end
  end
end
