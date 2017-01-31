defmodule Kickstart.SecretKey do
  def fetch do
    JOSE.JWK.from_oct_file(System.get_env("GUARDIAN_JWK_FILE"))
  end
end
