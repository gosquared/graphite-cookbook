[uWSGI](http://flask.pocoo.org/docs/deploying/uwsgi)

[Install Graphite 0.9.9 on Ubuntu 11.10 on EC2 with NGinx, uwsgi, supervisord, statsite, nagios agent](https://gist.github.com/1360928)

[Scalable realtime stats with Graphite](http://blog.adku.com/2011/10/scalable-realtime-stats-with-graphite.html)

[Getting Your Data Into Graphite](http://graphite.wikidot.com/getting-your-data-into-graphite)

# StatsD

[node.js](https://github.com/etsy/statsd)
[Ruby](https://github.com/reinh/statsd)
[Python](https://github.com/kiip/statsite)

# EC2 disk benchmarks

All done on a c1.medium, xfs & ext4 volumes.

    4GB write
    dd if=/dev/zero of=ddfile.big bs=1MB count=4k

    4GB read
    dd if=ddfile.big of=/dev/null

    # watch the progress
    watch -n1 pkill -USR1 dd

## Ephemeral storage

*4GB write*
4096000000 bytes (4.1 GB) copied, 133.974 s, 30.6 MB/s

*4GB read*
4096000000 bytes (4.1 GB) copied, 32.332 s, 127 MB/s

## Single 10GB EBS xfs volume

*4GB write*
4095663552 bytes (4.1 GB) copied, 85.7042 s, 47.8 MB/s

*4GB read*
4095999424 bytes (4.1 GB) copied, 36.7292 s, 112 MB/s

## RAID10 over 4 x 10 GB EBS xfs volumes

*4GB write*
4096000000 bytes (4.1 GB) copied, 92.5113 s, 44.3 MB/s

*4GB read*
4096000000 bytes (4.1 GB) copied, 109.419 s, 37.4 MB/s

## Single 10GB EBS ext4 volume

*4GB write*
4095962560 bytes (4.1 GB) copied, 93.0888 s, 44.0 MB/s

*4GB read*
4096000000 bytes (4.1 GB) copied, 36.6244 s, 112 MB/s

## RAID10 over 4 x 10 GB EBS ext4 volumes

*4GB write*
4096000000 bytes (4.1 GB) copied, 83.5105 s, 49.0 MB/s

*4GB read*
4096000000 bytes (4.1 GB) copied, 105.82 s, 38.7 MB/s
