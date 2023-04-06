module ArticlesHelper
  def formatted_date(datetime)
    datetime.strftime('%B %e, %Y')
  end
end
