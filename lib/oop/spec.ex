defmodule OOP.Spec do
  defmacro __using__(opts) do
    quote do
      use ExUnit.Case, unquote(opts)
      require OOP
      import OOP.Spec
    end
  end

  defmacro oop_test(message, do: block) do
    quote do
      ExUnit.Case.test(unquote(message)) do
        OOP.code do
          unquote(block)
        end
      end
    end
  end
end
