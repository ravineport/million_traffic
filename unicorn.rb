# coding: utf-8
@dir = "/home/player/million_traffic/"

worker_processes 2 # CPUのコア数に揃える
working_directory @dir

timeout 1000
listen "#{@dir}tmp/unicorn.sock"

pid "#{@dir}tmp/pids/unicorn.pid" #pidを保存するファイル

# unicornは標準出力には何も吐かないのでログ出力を忘れずに
stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"
