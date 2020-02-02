defmodule DoubanTask do
    use Task

    def start_link(_arg), do: Task.start_link(&start/0)

    defp start() do
        Process.sleep(:timer.seconds(5))
        pid = Process.whereis(DoubanShow)

        IO.puts("Start collecting books.")
        0..Tool.fetch_pages(:book)
        |> Enum.map(&Task.async(fn ->
            DoubanShow.collect(pid, {:book, &1})
        end))
        |> Task.yield_many()

        IO.puts("Start collecting movies.")

        0..Tool.fetch_pages(:movie)
        |> Enum.map(&Task.async(fn ->
            DoubanShow.collect(pid, {:movie, &1})
        end))
        |> Task.yield_many()

        IO.puts("\nAll Collected successed.")

        System.stop()
    end
end