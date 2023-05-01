class PlayersController < ApplicationController
  require "uri"
  require "net/http"
  require 'resolv-replace'
  require 'cgi'
  require 'json'

  def new
    @player = Player.new
  end

  def create
    my_hash = player_params.merge(wolfyApi(player_params[:uuid]))
    @player = Player.new(my_hash)
    uuid = wolfyApi(player_params[:uuid])
    if uuid.present? && player_params[:uuid].to_s.length > 20
      if @rank.to_i > 10
        @player.save
        redirect_to root_path
        flash[:notice] = "Résultat : #{@player.username}"
        session[:search] = @player
        session[:counter] ? session[:counter] += 1 : session[:counter] = 1
      else
        redirect_to root_path
        flash[:alert] = "Ce joueur n'a pas de grade."
      end
    else
      redirect_to root_path
      flash[:alert] = "UUID invalide... Vérifie les caractères"
    end
  end

  private

  def player_params
    params.require(:player).permit(:uuid)
  end

  def wolfyApi(uuid)
    url = URI("https://wolfy.net/api/leaderboard/player/#{CGI.escape(uuid)}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Get.new(url)
    request["Cookie"] = ENV["WOLFY_COOKIE"]
    response = https.request(request)
    if response.code == "200"
      parse = JSON.parse(response.read_body)
      @rank = parse["user"]["rank"]
      {
        username: parse["user"]["username"]
      }
    else
      return nil
    end
  end
end
