defmodule OOP.Def do
  defmacro defclass(name, do: block) do
    quote do
      defmodule unquote(name) do
        use OOP.Impl
        require OOP
        OOP.code do
          unquote(block)
        end
      end
    end
  end
end
