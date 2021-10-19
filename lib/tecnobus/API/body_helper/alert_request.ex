defmodule Tecnobus.API.BodyHelper.AlertRequest do
  @enforce_keys [:terid, :type, :starttime, :endtime]
  defstruct [:terid, :type, :starttime, :endtime]
end
