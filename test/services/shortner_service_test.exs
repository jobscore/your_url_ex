defmodule UrlShortner.ShortnerServiceTest do
  use UrlShortner.ConnCase

  alias UrlShortner.Url
  alias UrlShortner.ShortnerService

  test "#create_short_url, create a new url entry" do
    params = %{ "original_url" => "http://www.pudim.com.br" }

    { :ok, url } = UrlShortner.ShortnerService.create_short_url(params)

    assert url.clicks == 0
    assert url.url_hash != nil
    assert url.original_url == "http://www.pudim.com.br"
  end
end