class MessagesController < ApplicationController
  before_action :set_application, :set_chat, only: [:index, :show, :destroy, :update, :search]
  before_action :set_message, only: [ :show, :update, :destroy ]

  # GET /messages
  def index
    @messages = @chat.messages
    render json: @messages, :except=> [:id, :chat_id], status: :ok
  end

  # GET /messages/1
  def show
    render json: @message, :except=> [:id, :chat_id], status: :ok
  end

  # POST /messages
  def create
    message_number = get_next_number
    obj = [
      params[:application_token],
      params[:chat_number],
      message_number,
      params[:message]
    ]
    CreateMessageJob.perform_async(obj)
    render json: {number: message_number, message: params[:message]}, :except=> [:id, :chat_id], status: :created
  end

  # PATCH/PUT /messages/1
  def update
   # creating a hashmap and passing it
    obj = [
      params[:application_token],
      params[:chat_number],
      params[:number],
      params[:message]
    ]
    UpdateMessageJob.perform_async(obj)
    render json:{ message: "Updated Successfully"}, status: :ok
  end

  # # DELETE /messages/1
  def destroy
    @message.with_lock do
      @message.destroy!
    end
    @chat.with_lock do
      @chat.decrement!(:message_count)
    end
    render json:{ message: "Deleted Successfully!" }, status: :ok
  end

  # POST
  def search
    @result = Message.search(params[:message])
    render json: @result, :except=> [:id, :chat_id], status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by("token": params[:application_token])
      render json: { error: "Application not found" }, status: :not_found unless @application
    end

    def set_chat
      @chat = @application.chats.find_by("number": params[:chat_number]) if @application
      render json: { error: "Chat not found" }, status: :not_found unless @chat
    end

    def set_message
      @message = @chat.messages.find_by("number": params[:number]) if @chat
      render json: { error: "Message not found" }, status: :not_found unless @message
    end

    def get_next_number
      $redis_lock.lock("#{params[:application_token]}_#{params[:chat_number]}_next_message_number", 2000) do |locked|
        output = $redis.get("#{params[:application_token]}_#{params[:chat_number]}_next_message_number")
        $redis.set("#{params[:application_token]}_#{params[:chat_number]}_next_message_number", output.to_i + 1)
        return output
      end
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:message)
    end
end
