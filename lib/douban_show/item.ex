defmodule DoubanItem do
    def new, do: []

    def put(inst, value) do
        [value | inst]
    end

    defp make_sum(inst) do
        inst
        |> (&(:crypto.hash(:sha3_256, &1))).()
    end

    def make_id(inst) do
        with sum <- make_sum(inst) do
            [sum | inst]
        end
    end
end
