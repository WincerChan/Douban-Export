defmodule DoubanItem do
    def new, do: []

    def put(inst, value) do
        [value | inst]
    end

    def make_id(inst) do
        with sum <- :crypto.hash(:sha3_256, inst) do
            [sum | inst]
        end
    end
end
