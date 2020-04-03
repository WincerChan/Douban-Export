# DoubanShow

本项目的目的是收集豆瓣上标记的书记和电影，然后在博客的[页面](https://blog.itswincer.com/life/)展示，之前是用 Python 写的（在 `old_python` 分支），现作为我学习 Elixir 中的练手项目，主要有以下几方面考量：

1. Elixir 的语言特性比较与众不同：模式匹配、并发模型等；
2. Elixir 自带数据持久化工具（DETS），省去了 PostgreSQL 的依赖；
3. Elixir 是一门函数式编程语言，虽然我之前有接触过几门函数式编程语言（Lisp、SML），但均作为教学语言，没有生产经验，于是便考虑正式将 Elixir 作为本项目的重构语言。

## 运行

1. mix run --no-halt
2. iex lib/show.ex
3. Show.start()