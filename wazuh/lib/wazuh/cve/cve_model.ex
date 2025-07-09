defmodule Wazuh.CveModel do
  # , warn: false
  import Ecto.Query

  alias Wazuh.Repo
  alias Wazuh.Cve

  # Wazuh.CveModel.list()

  def list do
    # Repo.all(Cve)
    Repo.all(from(r in Cve, order_by: r.published))
  end

  # Wazuh.CveModel.get("CVE-2025-26693")
  def get(cveid) do
    # Repo.get(Cve, id)
    Repo.all(from(r in Cve, where: r.cveid == ^cveid))
  end

  @doc """
  Creates a Cve.

  ## Examples
      # con key string
      iex> Wazuh.CveModel.create(%{ "cveid"=> "124", "published"=> "2025 03 10", "name"=> "cve_name", "jsondata" => %{"keys"=>"value"}})
      {:ok, %Cve{}}

      iex> Wazuh.CveModel.create(%{ "badkey" => "bad_value"})
      {:error, %Ecto.Changeset{}}
      errors: []


  """

  def create(attrs \\ %{}) do
    %Cve{}
    |> Cve.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cve

  ## Examples

      iex> update(cve, %{keys: new_value})
      {:ok, %Cve{}}

      iex> update(cve, %{keys: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update(%Cve{} = cve, attrs) do
    cve
    |> Cve.changeset(attrs)
    |> Repo.update()
  end
end
