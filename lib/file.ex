defmodule LifeFile do
    use GenServer

    @filepath "/Users/wincer/Projects/MyBlog/source/life/index.md"
    @text """
    ---
    title: 生活
    comments: true
    date: 2017-06-15 10:56:58
    hide_license: true
    hide_outdated: true
    noreferrer: true
    thumbnail: https://ae01.alicdn.com/kf/HTB1sJ_aacnrK1RjSspk761uvXXaB.png
    ---
    
    我想成为一个自由且有趣的人，其中自由在于思想，有趣在于生活。
    
    读书和看电影，正是我生活中不可或缺的一部分，它们可以扩充我的视野、丰富我的知识面，让我了解其他完全不同的生活方式；同时，书和电影也塑造了我的主要价值观。
    
    我不愿在工作上耗费太多精力（我并没有把编程当成一份工作），因为对我来说，生命中显然有比工作更加重要的事，比如——好好生活。
    
    ---
    <center><font size=5>我看过的书籍和电影（2020）</font></center>
    {% stream %}
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
          {:put, value}   ->
            inst |> IO.binwrite(value)
          {:close} -> 
            inst |> File.close
        end
        
        {:noreply, inst}
    end

    def close(pid) do
        GenServer.cast(pid, {:close})
    end

end