class MessagesController < ApplicationController

SYSTEM_PROMPT = "You are an expert personal finance coach for young travelers on a tight budget.
Speak concisely, in friendly plain English, and return step-by-step, practical actions the user can take to improve their finances.
Always format the response in Markdown with a one-line summary, a short prioritized action list, and a 3-step immediate plan.
If you need user details (monthly income, recurring bills, currency, or goals), ask one clear question at a time."

  def create
    @chat = Chat.find(params[:chat_id])

    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      llm_response = @ruby_llm_chat.with_instructions(SYSTEM_PROMPT).ask(@message.content)
      @chat.messages.create(chat: @chat, content: llm_response.content, role: "assistant")

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to chat_path(@chat) }
      end

    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("new_message", partial: "messages/form", locals: { chat: @chat, message: @message }) }
        format.html { render "chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def build_conversation_history
    raw_block_array = []

    @chat.messages.each do |message|
      raw_block_array.push({ type: 'text', text: message.content })
    end

    raw_block = RubyLLM::Content::Raw.new(raw_block_array)

    @ruby_llm_chat.add_message(role: :system, content: raw_block)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
