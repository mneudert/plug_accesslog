[__DIR__, "logs/*.log"]
|> Path.join()
|> Path.wildcard()
|> Enum.each(&File.rm/1)

ExUnit.start()
