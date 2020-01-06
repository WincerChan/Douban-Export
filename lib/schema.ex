defmodule Database do 
    def get_env(name) do
        Application.get_env(:douban_show, name)
    end

    def init do
        {:ok, pid} = Postgrex.start_link(
            hostname: get_env(:hostname),
            username: get_env(:username),
            database: get_env(:database),
            password: get_env(:password))
        Agent.start_link(fn -> pid end, name: Pid)
        do_create()
    end

    def do_create do
        try do
            Postgrex.query!(get_conn(), "CREATE TABLE public.item (
                id uuid NOT NULL,
                category character varying(10) NOT NULL,
                info jsonb NOT NULL
            );", [])
        rescue
            _ in Postgrex.Error -> IO.puts("relation already been created")
        end
    end

    def get_conn do
        Agent.get(Pid, & &1)
    end

    def insert(movie_info) do
        id = :crypto.hash(:md5, movie_info[:url])
        try do
            _ = Postgrex.query!(get_conn(), "INSERT INTO item(id, category, info) VALUES($1, $2, $3);",
            [id, "movie", movie_info])
        rescue
            e in Postgrex.Error -> e.message
        end
    end
end
