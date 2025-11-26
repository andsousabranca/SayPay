class ChatsController < ApplicationController

  def show
    @chat = Chat.find(params[:id])
    @message = Message.new
    @messages = Message.all
  end

end
