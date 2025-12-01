class UnsplashService
  def initialize(country)
    @country = country
  end

  def call
    Unsplash::Photo.search("#{@country}")
  end
end
