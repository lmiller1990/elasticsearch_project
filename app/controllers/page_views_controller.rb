class PageViewsController < ApplicationController

  def index
    puts params
    searcher = ElasticSearcher.new
    result = searcher.search({
      urls: page_view_params[:urls].split(','),
      after: page_view_params[:after],
      before: page_view_params[:before],
      interval: page_view_params[:interval]
    })

    render json: JSON.pretty_generate(result)
  end

  private 

  def page_view_params
    params.permit(:urls, :before, :after, :interval)
  end
end
