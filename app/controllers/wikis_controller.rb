class WikisController < ApplicationController
  before_action :set_wiki, only: [:show, :edit, :update, :destroy]
  before_action :new_wiki, only: [:new, :create]
  before_action :new_wikis, only: [:index]
  before_action :authorizeWiki, except: [:index]
  before_action :authorizeWikis, only: [:index]

  # GET /wikis
  # GET /wikis.json
  def index
  end

  # GET /wikis/1
  # GET /wikis/1.json
  def show
  end

  # GET /wikis/new
  def new
  end

  # GET /wikis/1/edit
  def edit; end

  # POST /wikis
  # POST /wikis.json
  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user


    if @wiki.private and (not (current_user.premium? or current_user.admin?))
      flash[:alert] = "You have to be a premium member to create private Wikis"
      render :new
    else
      respond_to do |format|
        if @wiki.save
          format.html { redirect_to @wiki, notice: 'Wiki was successfully created.' }
          format.json { render :show, status: :created, location: @wiki }
        else
          format.html { render :new }
          format.json { render json: @wiki.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /wikis/1
  # PATCH/PUT /wikis/1.json
  def update

    wiki_private = wiki_params[:private]

    if wiki_private and (not (current_user.premium? or current_user.admin?))
      flash[:alert] = "You have to be a premium member to create private Wikis"
      render :new
    else
    respond_to do |format|
      if @wiki.update(wiki_params)
        format.html { redirect_to @wiki, notice: 'Wiki was successfully updated.' }
        format.json { render :show, status: :ok, location: @wiki }
      else
        format.html { render :edit }
        format.json { render json: @wiki.errors, status: :unprocessable_entity }
      end
    end
  end
  end

  # DELETE /wikis/1
  # DELETE /wikis/1.json
  def destroy
      respond_to do |format|
        if @wiki.destroy
        format.html { redirect_to wikis_url, notice: 'Wiki was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html {redirect_to wikis_url, notice: 'Wiki could not be destroyed'}
        format.json {render json: @wiki.errors, status: unprocessable_entity}
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_wiki
    @wiki = Wiki.find(params[:id])
  end

  def new_wiki
    @wiki = Wiki.new
  end

  def new_wikis
    @wikis = Wiki.all.visible_to(current_user)
  end

  def authorizeWiki
    authorize @wiki
  end

  def authorizeWikis
    authorize @wikis
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def wiki_params
    params.require(:wiki).permit(:title, :body, :private)
  end
end
