describe LogstashRails::Transport::LogstashTcp do

  before do
    @server = TCPServer.new(9000)

    @thread = Thread.new do
      client = @server.accept
      @received = client.gets
      client.close
    end
  end

  after do
    @server.close
  end

  let :logstash_tcp do
    LogstashRails::Transport::LogstashTcp.new(port: 9000)
  end

  it do
    logstash_tcp.should respond_to :push
  end

  it 'sends data over tcp' do
    logstash_tcp.push 'toto'
    logstash_tcp.destroy
    @thread.join
    @received.should eq 'toto'
  end
end
