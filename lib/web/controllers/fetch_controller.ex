defmodule Web.FetchController do
  use Web, :controller

  alias Domain.HttpClient

  def index(conn, _params) do
    {:ok, state} =
      HttpClient.request(
        Domain.HttpClient,
        "GET",
        "/owid/covid-19-data/master/public/data/vaccinations/country_data/Afghanistan.csv",
        [],
        nil
      )

    :ok = HttpClient.close_connection(Domain.HttpClient)

    json(conn, state.data)
  end
end
