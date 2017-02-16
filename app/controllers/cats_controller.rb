class CatsController < ApplicationController

  before_action :verify_owner, only: [:edit, :update]

  def index
    @cats = Cat.all
    render :index
  end

  def show
    @cat = Cat.find(params[:id])
    render :show
  end

  def new
    @cat = Cat.new
    render :new
  end

  def create
    @cat = Cat.new(cat_params)
    if @cat.save
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :new
    end
  end

  def edit
    @cat = Cat.find(params[:id])
    render :edit
  end

  def update
    @cat = Cat.find(params[:id])
    if @cat.update_attributes(cat_params)
      redirect_to cat_url(@cat)
    else
      flash.now[:errors] = @cat.errors.full_messages
      render :edit
    end
  end

  private

  def cat_params
    cat_params = params.require(:cat)
      .permit(:age, :birth_date, :color, :description, :name, :sex)
    cat_params[:user_id] = current_user.id
    cat_params
  end

  def verify_owner
    if current_user.cats.find(params[:id]).nil?
      current_user.errors[:not] << "your cat!"
      flash[:errors] = current_user.errors.full_messages
      redirect_to cat_url(id: params[:id])
    end

    # curr_cat = Cat.find(params[:id])
    #
    # unless curr_cat.owner.id == current_user.id
    #   current_user.errors[:not] << "your cat!"
    #   flash[:errors] = current_user.errors.full_messages
    #   redirect_to cat_url(curr_cat)
    # end
  end

end
