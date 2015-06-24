module ApiHelper
  def basic_auth(u,p)
    auth = ActionController::HttpAuthentication::Basic.encode_credentials(u,p)
  end

  def benchmark(threshold, &block)
    expect(b = Benchmark.realtime{ block.yield }).to be < threshold
  end
end
