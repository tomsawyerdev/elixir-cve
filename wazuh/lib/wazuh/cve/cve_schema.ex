defmodule Wazuh.Cve do
  use Ecto.Schema
  import Ecto.Changeset

  # @primary_key {:id, :binary_id, autogenerate: false}
  schema "cve" do
    field(:cveid, :string)
    field(:published, :string)
    field(:name, :string)
    field(:jsondata, :map)
  end

  @doc false
  # for create and update
  def changeset(cve, attrs) do
    cve
    |> cast(attrs, [:cveid, :published, :name, :jsondata])
    |> validate_required([:cveid, :published, :name, :jsondata])
    |> unique_constraint(:cveid, name: :cve_cveid_index)
  end
end
