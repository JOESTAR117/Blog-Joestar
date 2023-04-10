class ArticlesController < ApplicationController
  before_action :set_article, only: %i[show edit update destroy]

  def index
    @highlights = Article.order(created_at: :desc).first(3)

    current_page = (params[:page] || 1).to_i

    highlight_ids = @highlights.pluck(:id).join(',')

    @articles = Article.order(created_at: :desc)
                       .where("id NOT IN(#{highlight_ids})")
                       .page(current_page).per(5)
  end

  def show
    @article
  end

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

  def edit
    @article
  end

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
    params.require(:article).permit(:title, :body)
  end
end
