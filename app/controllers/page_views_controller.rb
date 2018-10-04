class PageViewsController < ApplicationController

  def index
    searcher = ElasticSearcher.new

    result = searcher.search({
      urls: get_urls,
      after: page_view_params[:after],
      before: page_view_params[:before],
      interval: page_view_params[:interval]
    })

    render json: JSON.pretty_generate(result)
  end

  private 

  def get_urls
    if page_view_params[:urls]
      page_view_params[:urls].split(',')
    else
      []
    end
  end

  def page_view_params
    params.permit(:urls, :before, :after, :interval)
  end
end
