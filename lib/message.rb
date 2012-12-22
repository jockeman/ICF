class Message
  attr_reader :user, :channel, :message, :action
  def initialize(user, raw_message)
    @user = user
    @channel = raw_message.channel
    raw_message.payload =~ /^\.([^\s]*)\s*(.*)/ rescue nil
    @action = ($1 rescue nil)
    @message = ($1 ? $2 : raw_message.payload rescue nil)
  end
end
