class GamesController < ApplicationController
  before_filter :authenticate_user!

  # GET /games
  # GET /games.json
  def index
    # if current_user.admin?
      # @games = Game.all
    # else
    #   @games = current_user.games.all
    # end
    # @owned_games = current_user.game_user_joins.owned.map(&:game)
    @owned_games = current_user.games.where(game_user_joins: {owner: true})
    @joined_games = current_user.games.all - @owned_games
    @open_games = Game.where(open: true) - @owned_games - @joined_games

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @open_games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    # if current_user.admin?
      @game = Game.find(params[:id])
    # else
    #   @game = current_user.games.find(params[:id])
    # end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @users = User.all
    @game = current_user.games.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @users = User.all
    if current_user.admin?
      @game = Game.find(params[:id])
    else
      @game = current_user.games.find(params[:id])
    end
  end

  # POST /games
  # POST /games.json
  def create
    @game = current_user.games.new(params[:game])
    # @game.users << current_user
    # @game.users[current_user.id].update(owner: true)
    join = GameUserJoin.create(user_id: current_user.id, owner: true)
    @game.game_user_joins << join

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    if current_user.admin?
      @game = Game.find(params[:id])
    else
      @game = current_user.games.find(params[:id])
    end

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    if current_user.admin?
      @game = Game.find(params[:id])
    else
      @game = current_user.games.find(params[:id])
    end
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  # POST /games/1/join
  def join
    @game = Game.find(params[:id])
    @game.users << current_user

    respond_to do |format|
      format.html {redirect_to @game}
    end
  end

  # POST /games/1/leave
  def leave
    @game = Game.find(params[:id])
    @game.users.delete(current_user)
    if @game.users.count == 0
      @game.destroy
    end
    

    respond_to do |format|
      format.html {redirect_to @game}
    end
  end
end
