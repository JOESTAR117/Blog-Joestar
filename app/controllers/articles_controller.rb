class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @highlights = Article.desc_order.first(3)

    current_page = (params[:page] || 1).to_i

    highlight_ids = @highlights.pluck(:id).join(',')

    @articles = if highlight_ids.present?
                  Article.without_highlights(highlight_ids)
                         .desc_order
                         .page(current_page)
                else
                  Article.order(created_at: :desc)
                         .page(current_page)
                end
  end

  def show; end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html do
          redirect_to @article, notice: 'Article was successfully created.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    @article
    respond_to do |format|
      if @article.update(article_params)
        format.html do
          redirect_to @article, notice: 'Article was successfully updated.'
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy

    respond_to do |format|
      format.html do
        redirect_to root_path, notice: 'Article was successfully destroyed.'
      end
    end
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :category_id)
  end
end
