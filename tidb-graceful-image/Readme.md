build
```
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t dulao5/graceful-tidb:v8.5.0 \
  -f Dockerfile . \
  --push

docker manifest inspect dulao5/graceful-tidb:v8.5.0
```

testing

```
$ docker run --rm -it -p4000:4000 -p10080:10080 -p10088:10088 -eGRACEFUL_BEFORE_WAIT_TIME=90 dulao5/graceful-tidb:v8.5.0 2>&1 | tee logs/tidb-local.log 

Mon Mar 17 11:58:54 UTC 2025 Starting readiness probe on port 10088...
Mon Mar 17 11:58:54 UTC 2025 Readiness probe started with PID 8
2025/03/17 11:58:54.959386 9f258f28e722 socat[8] W ioctl(5, IOCTL_VM_SOCKETS_GET_LOCAL_CID, ...): Inappropriate ioctl for device
2025/03/17 11:58:54.959443 9f258f28e722 socat[8] N listening on AF=2 0.0.0.0:10088
Mon Mar 17 11:58:54 UTC 2025 Starting TIDB...
Mon Mar 17 11:58:54 UTC 2025 TIDB started with PID 11
...
```

mysql ping
```
$ mysqladmin ping -h 127.0.0.1 -u root --password="" -P10088
mysqld is alive
```
tidb-log:
```
2025/03/17 12:09:08.747291 ae46054d2ff4 socat[8] N accepting connection from AF=2 172.17.0.1:45508 on AF=2 172.17.0.2:10088
```

kill-tidb
```
^C
Mon Mar 17 12:10:17 UTC 2025 Shutdown initiated...
Mon Mar 17 12:10:17 UTC 2025 Stopping readiness probe (PID: 8)...
2025/03/17 12:10:17.601719 ae46054d2ff4 socat[8] N socat_signal(): handling signal 15
2025/03/17 12:10:17.601729 ae46054d2ff4 socat[8] W exiting on signal 15
2025/03/17 12:10:17.601731 ae46054d2ff4 socat[8] N socat_signal(): finishing signal 15
2025/03/17 12:10:17.601762 ae46054d2ff4 socat[8] N exit(143)
Mon Mar 17 12:10:17 UTC 2025 Waiting 90 seconds before stopping TIDB...
```

mysql ping
```
$ mysqladmin ping -h 127.0.0.1 -u root --password="" -P10088
mysqladmin: connect to server at '127.0.0.1' failed
error: 'Lost connection to MySQL server at 'handshake: reading initial communication packet', system error: 11'
```

after 90s
```
Mon Mar 17 12:11:47 UTC 2025 Stopping TIDB (PID:11)...                                                                                                                                                                                            
[2025/03/17 12:11:47.606 +00:00] [INFO] [signal_posix.go:54] ["got signal to exit"] [signal=terminated]  
```