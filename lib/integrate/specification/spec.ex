defmodule Integrate.Specification.Spec do
  @moduledoc """
  User provided configuration for claims or notifications.

  This records the original user input, for example `fields: ["*"]` style
  instructions, before the values are parsed and expanded into structured
  `Integrate.Claims.Claim`s and `Integrate.Claims.Field`s.
  """
  use Integrate, :schema

  @types %{
    claims: "CLAIMS",
    notifications: "NOTIFICATIONS"
  }

  def types(key) do
    @types
    |> Map.fetch!(key)
  end

  schema "specs" do
    field :type, :string

    embeds_many :match, Specification.Match
    belongs_to :stakeholder, Stakeholders.Stakeholder

    timestamps()
  end

  @doc false
  def changeset(spec, attrs) do
    spec
    |> cast(attrs, [:type, :stakeholder_id])
    |> validate_required([:type, :stakeholder_id])
    |> validate_inclusion(:type, Map.values(@types))
    |> cast_embed(:match)
    |> assoc_constraint(:stakeholder)
  end
end