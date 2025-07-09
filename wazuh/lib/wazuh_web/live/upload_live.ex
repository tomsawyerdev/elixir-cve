# lib/my_app_web/live/upload_live.ex
defmodule WazuhWeb.UploadLive do
  use WazuhWeb, :live_view

  alias Wazuh.CveModel

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.json), max_entries: 1)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    # validar si ya existe el reporte
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, _entry ->
        # IO.inspect(path, label: "save --------------")

        result = get_json(path)
        IO.inspect(result, label: "save --------------")

        {:ok, result}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  def get_json(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body),
         {:ok, cve} <- is_cve(json),
         {:ok, cve} <- is_unique(cve),
         {:ok, msg} <- create(cve) do
      msg
    else
      {:error, msg} -> msg
      _ -> "Uncaught error"
    end
  end



  defp is_cve(json) do
    IO.inspect(Map.keys(json), label: "is_cve, keys")
    metadata = Map.get(json, "cveMetadata")
    # IO.inspect(metadata, label: "is_cve, metadata")

    case metadata do
      nil -> {:error, "Missing key: cveMetadata"}
      _ -> build_cve(metadata, json)
    end
  end

  defp build_cve(
         %{
           "cveId" => cveId,
           "assignerShortName" => assignerShortName,
           "datePublished" => datePublished
         },
         json
       ) do
    #
    cve = %{
      "cveid" => cveId,
      "name" => assignerShortName,
      "published" => datePublished,
      "jsondata" => json
    }

    {:ok, cve}
  end

  defp build_cve(_, _) do
    {:error, "Missing many keys"}
  end

  defp is_unique(%{"cveid" => cveid} = cve) do
    # IO.inspect(cve["cveid"], label: "cve_id")
    IO.inspect(cveid, label: "is_unique, cveid")

    case CveModel.get(cveid) do
      [_] -> {:error, "Item already exist"}
      [] -> {:ok, cve}
    end
  end

  defp create(cve) do
    IO.inspect(Map.keys(cve), label: "Create cve, keys")

    case CveModel.create(cve) do
      {:ok, _} -> {:ok, "Cve was created"}
      {:error, _} -> {:error, "Error happenned while creating CVE"}
    end
  end
end
