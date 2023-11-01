class RetirementsController < ApplicationController
  def new; end

  def create
    if current_user.destroy
      reset_session
      respond_to do |format|
        format.html { redirect_to root_path, notice: "退会完了しました" }
        format.js { render :js => "window.location = '#{root_path}'" }
        flash[:notice] = "退会完了しました"
      end
    end
  end
end
