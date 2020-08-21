class CategoryController < ApplicationController
  before_action :authorized

  def index
    @all_categories = Category.where(user_id: @user.id)
    if @all_categories
      render :json => {
          :data => @all_categories
      }
    else
      render :json => {
          :response => "There are no categories to show for this user."
      }
    end
  end

  def show
    if(@show_category = Category.find_by_id(params[:id])).present? && @show_category.user_id == @user.id
      render :json => {
          :data => @show_category
      }
    else
      render :json => {
          :response => "This category does not exist to show."
      }
    end
  end

  def create
    @new_category = Category.new(category_params)
    @new_category.user_id = @user.id
    @new_category.created_by = @user.id
    if @new_category.save
      render :json => {
          :data => @new_category
      }
    else
      render :json => {
          :response => "Failed to create new category"
      }
    end
  end

  def update
    if (@update_category = Category.find_by_id(params[:id])).present? && @update_category.user_id == @user.id
      @update_category.update(category_params)
      render :json => {
          :data => @update_category
      }
    else
      render :json => {
          :response => "This category does not exist for you to update"
      }
    end
  end

  def destroy
    if (@delete_category = Category.find_by_id(params[:id])).present? && @delete_category.user_id == @user.id
      @delete_category.destroy
      render :json => {
          :response => "You have successfully deleted the category",
          :data => @delete_category
      }
    else
      render :json => {
          :response => "This category does not exist to delete"
      }
    end
  end

  private

  def category_params
    params.permit(:title, :description)
  end
end
