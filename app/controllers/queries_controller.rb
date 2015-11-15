class QueriesController < ApplicationController
 before_filter :authenticate_user!

  def index
  end

  def create
   @query = params[:query]
   @search = Keyword.where("word like ? AND user_id = ?",@query,current_user.id)
  end


  def delete_all_data
   @keyword = Keyword.where(user_id: current_user.id)
   @keyword_count = KeywordCount.where(user_id: current_user.id)
   @keyword_result = KeywordResult.where(user_id: current_user.id)
   @keyword_page = KeywordPage.where(user_id: current_user.id)
   if @keyword.delete_all && @keyword_count.delete_all && @keyword_result.delete_all &&  @keyword_page.delete_all
    redirect_to keywords_path, notice: "All Data has been deleted"
   else
    redirect_to keywords_path, notice: "No Data to be deleted"
   end
  end

end
