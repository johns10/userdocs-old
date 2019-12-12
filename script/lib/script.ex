defmodule Script do

  defdelegate generate_script(script, list, types), to: Script.Script

end
