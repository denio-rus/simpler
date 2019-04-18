class TestsController < Simpler::Controller

  def index
    @time = Time.now
    render plain: 'tests/list'
  end

  def create; end

  def show; end

end
