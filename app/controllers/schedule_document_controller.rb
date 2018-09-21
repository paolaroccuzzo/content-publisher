class ScheduleDocumentController < ApplicationController
  def pick_date
    @document = Document.find_by_param(params[:id])
  end

  def schedule
    document = Document.find_by_param(params[:id])

    scheduled_at = DateTime.new(
      params[:document]["scheduled_at(1i)"].to_i,
      params[:document]["scheduled_at(2i)"].to_i,
      params[:document]["scheduled_at(3i)"].to_i,
      params[:document]["scheduled_at(4i)"].to_i,
      params[:document]["scheduled_at(5i)"].to_i,
    )

    document.update!(scheduled_at: scheduled_at)

    redirect_to document_path(document)
  end
end
