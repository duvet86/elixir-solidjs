defmodule Web.FetchController do
  use Web, :controller

  def index(conn, _params) do
    # Task.Supervisor.start_link(name: :task_supervisor)

    # Task.Supervisor.async_nolink(:task_supervisor, fn -> test() end)

    # task = Task.async(fn -> test() end)

    # Task.await(task)

    {:ok, httpConn} = Mint.HTTP.connect(:https, "raw.githubusercontent.com", 443)

    {:ok, httpConn, request_ref} =
      Mint.HTTP.request(
        httpConn,
        "GET",
        "/owid/covid-19-data/master/public/data/vaccinations/country_data/Afghanistan.csv",
        [],
        nil
      )

    receive do
      message ->
        {:ok, httpConn, responses} = Mint.HTTP.stream(httpConn, message)

        # filter the mint-data-respones
        body =
          responses
          |> Enum.filter(fn
            {:data, ^request_ref, _} -> true
            _ -> false
          end)
          |> Enum.map(fn {_, _, data} -> data end)

        # decode the json response body
        # json = Jason.decode!(body)

        # decode the actual README from which GitHub returns as a base64 encoded string
        # readme = Base.decode64!(json["content"], ignore: :whitespace)

        Mint.HTTP.close(httpConn)

        json(conn, body)
    end
  end

  # defp fetch do
  #   {:ok, httpConn} = Mint.HTTP.connect(:https, "raw.githubusercontent.com", 443)

  #   {:ok, httpConn, request_ref} =
  #     Mint.HTTP.request(
  #       httpConn,
  #       "GET",
  #       "/owid/covid-19-data/master/public/data/vaccinations/country_data/Afghanistan.csv",
  #       [],
  #       nil
  #     )

  #   receive do
  #     message ->
  #       {:ok, httpConn, mint_responses} = Mint.HTTP.stream(httpConn, message)

  #       # filter the mint-data-respones
  #       body =
  #         mint_responses
  #         |> Enum.filter(fn
  #           {:data, ^request_ref, _} -> true
  #           _ -> false
  #         end)
  #         |> Enum.map(fn {_, _, data} -> data end)

  #       # decode the json response body
  #       json = Jason.decode!(body)

  #       # decode the actual README from which GitHub returns as a base64 encoded string
  #       # readme = Base.decode64!(json["content"], ignore: :whitespace)

  #       Mint.HTTP.close(httpConn)
  #       # readme
  #   end

  #   # receive do
  #   #   message ->
  #   #     {:ok, _, responses} = Mint.HTTP.stream(httpConn, message)

  #   #     for response <- responses do
  #   #       case response do
  #   #         {:status, ^request_ref, status_code} ->
  #   #           IO.puts("> Response status code #{status_code}")

  #   #         {:headers, ^request_ref, _} ->
  #   #           nil

  #   #         # IO.puts("> Response headers: #{inspect(headers)}")

  #   #         {:data, ^request_ref, data} ->
  #   #           IO.puts("> Response body")
  #   #           IO.inspect(data)

  #   #         {:done, ^request_ref} ->
  #   #           IO.puts("> Response fully received")

  #   #         {:error, ^request_ref, reason} ->
  #   #           IO.puts("> Reason #{reason}")
  #   #       end
  #   #     end
  #   # end

  #   # Mint.HTTP.close(httpConn)
  # end
end
