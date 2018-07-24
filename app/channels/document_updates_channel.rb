class DocumentUpdatesChannel < ActionCable::Channel::Base
  def subscribed
    stream_from "updates:#{params[:id]}"
  end
end
