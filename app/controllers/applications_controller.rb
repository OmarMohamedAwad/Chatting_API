class ApplicationsController < ApplicationController
  before_action :set_application, only: [ :show, :update, :destroy ]
  before_action :application_params, only: [:create, :update]

  # GET /applications
  def index
    @applications = Application.all
    render json: @applications, :except=> [:id], status: :ok
  end

  # GET /applications/1
  def show
    render json: @application, :except=> [:id], status: :ok
  end

  # POST /applications
  def create
    timestamp = Time.now.to_i
    token = SecureRandom.hex(8) + timestamp.to_s
    obj = [
      token,
      params[:name]
    ]
    render json: { token: token }, status: :created
  end

  # PATCH/PUT /applications/:token
  def update
    obj = [
      params[:token],
      params[:name]
    ]
    UpdateApplicationJob.perform_async(obj)
    render json:{ message: "Updated Successfully"}, status: :ok
  end

  # DELETE /applications/:token
  def destroy
    @application.destroy
    render json:{ message: "Deleted Successfully!" }, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by("token": params[:token])
      render json: { error: "Application not found" }, status: :not_found unless @application
    end

    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end
end


