defmodule WazuhWeb.CvesJSON do
  alias Wazuh.Cve

  @doc """
  Renders a list of items.
  """
  def index(%{items: items}) do
    for(e <- items, do: data(e))
  end

  @doc """
  Renders a single item.
  """
  def show(%{item: item}) do
    data(item)
  end

  defp data(%Cve{} = cve) do
    %{
      id: cve.cveid,
      published: cve.published
    }
  end
end
