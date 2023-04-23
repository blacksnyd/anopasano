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
    uuid = my_hash[:uuid]
    if uuid.present? && uuid.delete("-").length > 20
      @player.save
      redirect_to root_path
      flash[:notice] = @player.username
      session[:search] = @player
      if session[:counter]
        session[:counter] += 1
      else
        session[:counter] = 1
      end
    else
      redirect_to root_path, alert: "UUID invalide"
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
      {
        username: parse["user"]["username"]
      }
    else
      return nil
    end
  end
end
