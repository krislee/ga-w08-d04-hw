class RecipesController < ApplicationController
  before_action :authorized

  def index
    # if (@recipe_category = Category.find_by_id(params[:category_id])).present?
    if Category.exists?(params[:category_id])
      if(@category_recipes = Category.where(user_id: @user.id, id: params[:category_id])).present?
        # if @category_recipes.find_by_id(params[:category_id]).recipes
          render :json => {
              # :response => @recipe_category.recipes
              :data => @user.recipes
          }
        else
          render :json => {
              :response => "This user has not made this category."
          }
        end
      else
        render :json => {
            :response => "This user has not made this category."
        }
      end
    # end
  end

  def show
    if Category.exists?(params[:category_id])
      # if (@show_recipe = Category.find_by_id(params[:category_id]).recipes.find_by_id(params[:id])).present?
      if (@user_categories = Category.where(user_id: @user.id, id: params[:category_id])).present?
        if (@show_one_user_recipe = @user.recipes.find_by_id(params[:id]))
          render :json => {
              :data => @show_one_user_recipe
          }
        else
          render :json => {
              :response => "The recipe in this category does not exist."
          }
        end
      end
    else
      render :json => {
          :response => "The user has not made this category."
      }
    end
  end

  def create
    @new_recipe = Recipe.new(recipes_params)
    if Category.exists?(@new_recipe.category_id)
      if @new_recipe.save
        render :json => {
            :data => @new_recipe
        }
      else
        render :json => {
            :error => "Failed to save the new recipe"
        }
      end
    else
      render :json => {
          :error => "Failed to find the category the recipe belongs to"
      }
    end
  end

  def update
    # if Category.exists?(params[:category_id])
      if(@update_recipe = Category.where(user_id: @user.id, id: params[:category_id])).present?
        if (@user_updated_recipe = @user.recipes.find_by_id(params[:id]))
          @user_updated_recipe.update(recipes_params)
          render :json => {
              :data => @user_updated_recipe
          }
        else
          render :json => {
              :response => "This recipe cannot be updated because it does not exist in this category"
          }
        end
      # end
      else
        render :json => {
            :response => "This category does not exist"
        }
      end
  end

  def destroy
    if(@user_recipe = Category.where(user_id: @user.id, id: params[:category_id])).present?
      if (@destroy_recipe = @user.recipes.find_by_id(params[:id])).present?
        @destroy_recipe.destroy
        render :json => {
            :data => @destroy_recipe
        }
      else
        render :json => {
            :response => "This recipe cannot be deleted because it does not exist in this category"
        }
      end
    else
      render :json => {
          :response => "This category does not exist so it cannot be deleted"
      }
    end
  end

  private

  def recipes_params
    params.permit(:name, :ingredients, :directions, :notes, :tags, :category_id)
  end
end
