class Api::V1::EntriesController < Api::V1::BaseController
  #before_action entry_params
  def set
    render(

        json: ActiveModel::ArraySerializer.new(params).to_json
    )

  end
  private
  def entry_params
    params.require(:apikey).permit(:address,:city,:ap)
  end

end