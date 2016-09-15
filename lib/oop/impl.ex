defmodule OOP.Impl do
  defmacro __using__(_opts) do
    quote do
      use GenServer
      import OOP.Impl
      @state_mod Module.concat(__MODULE__, State)
    end
  end

  defmacro fields(fields_dict) do
    quote do
      defmodule State do
        defstruct unquote(fields_dict)
      end
    end
  end

  defmacro initialize(opts \\ [], do: block) do
    quote do
      def start_link(opts \\ []) do
        opts = unquote(opts) ++ opts
        var!(this, __MODULE__) = %@state_mod{}
        state = unquote(block)
        GenServer.start_link(__MODULE__, state)
      end

      def new(opts \\ []) do
        {:ok, pid} = start_link(opts)
        pid
      end
    end
  end

  defmacro defmethod(name, params \\ [], do: block) do
    block = prepare_defmethod_block(block)
    quote do
      def handle_call({unquote(name), unquote(params)}, _from, state) do
        var!(this, __MODULE__) = state
        {res, state} = unquote(block)
        {:reply, res, state}
      end
    end
  end

  defmacro defproc(name, params \\ [], do: block) do
    block = prepare_defproc_block(block)
    quote do
      def handle_cast({unquote(name), unquote(params)}, state) do
        var!(this, __MODULE__) = state
        state = unquote(block)
        {:noreply, state}
      end
    end
  end

  defmacro this do
    quote do
      var!(this, __MODULE__)
    end
  end

  defp prepare_defmethod_block({:__block__, lines, statements}) do
    [return | other] = Enum.reverse(statements)
    statements = [{return, {:this, [], nil}} | other] |> Enum.reverse
    {:__block__, lines, statements}
  end
  defp prepare_defmethod_block(return_stmt) do
    {return_stmt, {:this, [], nil}}
  end

  defp prepare_defproc_block({:__block__, lines, statements}) do
    statements = statements ++ [{:this, [], nil}]
    {:__block__, lines, statements}
  end
  defp prepare_defproc_block(last_stmt) do
    {:__block__, [], [last_stmt, {:this, [], nil}]}
  end
end
