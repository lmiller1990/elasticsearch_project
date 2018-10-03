class PageViewsController < ApplicationController

  def index
    puts params
    searcher = ElasticSearcher.new
    puts 'before', page_view_params[:before]
    puts 'after', page_view_params[:after]
    result = searcher.search({
      urls: urls,
      after: page_view_params[:after],
      before: page_view_params[:before],
      interval: page_view_params[:interval]
    })

    # render json: JSON.pretty_generate(result)
    render json: result
  end

  private 

  def urls
    if page_view_params[:urls]
      page_view_params.split(',')
    else
      []
    end
  end

  def page_view_params
    params.permit(:urls, :before, :after, :interval)
  end
end
