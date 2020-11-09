defmodule LifeFile do
  use GenServer

  @filepath "./life.md"
  @text """
  ---
  title: "Life"
  date: 2019-05-28
  slug: "life"
  cover: https://ae01.alicdn.com/kf/HTB1sJ_aacnrK1RjSspk761uvXXaB.png
  ---

  我想成为一个自由且有趣的人，其中自由在于思想，有趣在于生活。

  阅读与观影，是我二十余年的生活里不可或缺的一部分：我喜欢用它们扩充我的视野、丰富我的知识面，让我了解其它完全不同的生活方式；同时，它们也塑造了我主要的思想和价值观。

  我不愿在工作上耗费太多精力（我并没有把写代码当成一份工作），因为对我来说，生命中显然有比工作更加重要的事，比如——好好生活。

  {{< grid "life" >}}
  """
  def new do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    {:ok, file} = File.open(@filepath, [:write])
    file |> IO.binwrite(@text)
    {:ok, file}
  end

  def handle(pid) do
    GenServer.call(pid, {:get})
  end

  def handle_call({:get}, _, inst) do
    {:reply, inst, inst}
  end

  def put(pid, value) do
    GenServer.cast(pid, {:put, value})
  end

  def handle_cast(operation, inst) do
    case operation do
      {:put, value} ->
        inst |> IO.binwrite(value) |> IO.inspect()

      {:close} ->
        inst |> File.close()
    end

    {:noreply, inst}
  end

  def close(pid) do
    GenServer.cast(pid, {:close})
  end
end
