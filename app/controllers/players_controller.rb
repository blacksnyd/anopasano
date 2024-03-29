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
        flash[:notice] = "L'UUID <strong>#{@player.uuid}</strong> appartient à <strong>#{@player.username}</strong>"
        session[:history] ||= []
        session[:history] << @player
      else
        redirect_to root_path
        flash[:alert] = "Ce joueur n'a pas de grade."
      end
    else
      redirect_to root_path
      flash[:alert] = "L'UUID saisi n'existe pas ou n'est pas valide."
    end
  end

  private

  def player_params
    params.require(:player).permit(:uuid)
  end

  def wolfyApi(uuid)
    url = URI("https://wolfy.net/api/leaderboard/player/#{CGI.escape(uuid.strip)}")
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
