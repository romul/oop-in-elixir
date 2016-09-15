defmodule OOP do
  defmacro code(do: block) do
    {new_ast, _} = Macro.prewalk(block, [], &replace_calls/2)
    new_ast
  end

  defp replace_calls({:~>, _, [pid, {method_name, _, args}]}, acc) do
    args = args || []
    ast = quote do
      GenServer.call(unquote(pid), {unquote(method_name), unquote(args)})
    end
    {ast, acc}
  end
  defp replace_calls({:~>>, _, [pid, {method_name, _, args}]}, acc) do
    args = args || []
    ast = quote do
      GenServer.cast(unquote(pid), {unquote(method_name), unquote(args)})
    end
    {ast, acc}
  end
  defp replace_calls({:defmethod, _, [{method_name, _, args}, [do: block]]}, acc) do
    args = args || []
    ast = quote do
      OOP.Impl.defmethod unquote(method_name), unquote(args) do
        unquote(block)
      end
    end
    {ast, acc}
  end
  defp replace_calls({:defproc, _, [{method_name, _, args}, [do: block]]}, acc) do
    args = args || []
    ast = quote do
      OOP.Impl.defproc unquote(method_name), unquote(args) do
        unquote(block)
      end
    end
    {ast, acc}
  end
  defp replace_calls(node, acc), do: {node, acc}

end
