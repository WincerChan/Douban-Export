defmodule DoubanTask do
  use Task

  def start_link(_arg), do: Task.start_link(&start/0)

  def book(pid) do
    IO.puts("Start collecting books.")

    Tool.enumerate_pages(:book)
    |> Enum.map(
      &Task.async(fn ->
        DoubanShow.collect(pid, {:book, &1})
      end)
    )
    |> Task.yield_many()

    IO.puts("End collecting book.")
  end

  def movie(pid) do
    IO.puts("Start collecting movies.")

    Tool.enumerate_pages(:movie)
    |> Enum.map(
      &Task.async(fn ->
        DoubanShow.collect(pid, {:movie, &1})
      end)
    )
    |> Task.yield_many()
  end

  defp start() do
    IO.puts("Please wait 3 seconds...")
    Process.sleep(:timer.seconds(3))
    pid = Process.whereis(DoubanShow)

    book_task = Task.async(fn -> book(pid) end)
    movie_task = Task.async(fn -> movie(pid) end)
    Task.await(book_task)
    Task.await(movie_task)

    IO.puts("\nAll Collected successed.")
    IO.puts("Now starting draw collected items...")
    Show.start()
    System.stop()
  end
end
