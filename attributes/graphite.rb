### GENERAL
#
default[:graphite][:home]    = "/opt/graphite"
default[:graphite][:version] = "0.9.9"



### CARBON - THE DATA AGGREGATOR
#
# By default, everything will be installed in /opt/graphite.
# It strongly recommended that you do not change the default install path.
# Strange problems can ensue if you do.
#
default[:graphite][:carbon][:dir]       = "carbon-#{graphite.version}"
#
# Limit the size of the cache to avoid swapping or becoming CPU bound.
# Sorts and serving cache queries gets more expensive as the cache grows.
# Use the value "inf" (infinity) for an unlimited cache size.
default[:graphite][:carbon][:max_cache_size] = "inf"
#
# Limits the number of whisper update_many() calls per second, which effectively
# means the number of write requests sent to the disk. This is intended to
# prevent over-utilizing the disk and thus starving the rest of the system.
# When the rate of required updates exceeds this, then carbon's caching will
# take effect and increase the overall throughput accordingly.
default[:graphite][:carbon][:max_updates_per_second] = 1000
#
# Softly limits the number of whisper files that get created each minute.
# Setting this value low (like at 50) is a good way to ensure your graphite
# system will not be adversely impacted when a bunch of new metrics are
# sent to it. The trade off is that it will take much longer for those metrics'
# database files to all get created and thus longer until the data becomes usable.
# Setting this value high (like "inf" for infinity) will cause graphite to create
# the files quickly but at the risk of slowing I/O down considerably for a while.
default[:graphite][:carbon][:max_creates_per_minute] = 50
#
# Receiving interface
default[:graphite][:carbon][:line_receiver_interface] = "0.0.0.0"
default[:graphite][:carbon][:line_receiver_port]      = "2003"
#
# AMQP
default[:graphite][:carbon][:amqp][:enable]              = "False"
default[:graphite][:carbon][:amqp][:host]                = "localhost"
default[:graphite][:carbon][:amqp][:port]                = 5672
default[:graphite][:carbon][:amqp][:vhost]               = "/"
default[:graphite][:carbon][:amqp][:user]                = "guest"
default[:graphite][:carbon][:amqp][:password]            = "guest"
default[:graphite][:carbon][:amqp][:exchange]            = "graphite"
default[:graphite][:carbon][:amqp][:metric_name_in_body] = "False"
#
# The default values in the examples are sane, but it is strongly recommended
# to consider how much data you would like to retain. By default, it will be
# saved for 1 day in 1 minute intervals. This is set in the whisper files
# individually, and changing the value here will not alter existing metrics. A
# conversion script (provided with Graphite) can be used to change these later.
# Many people will want to store more than one day's worth of data. If you
# think that you may want to track trends week over week, month over month or
# year over year, you may want to store 13 months (1 year + 1 month) or perhaps
# even 2 - 3 years worth of data.
# More info on data retention: http://graphite.wikidot.com/getting-your-data-into-graphite
#
# REALTIME GRAPHS
# retentions = 1:14d, 10:61d, 1m:183d, 10m:3y
# 2 week of 1 second granularity
# 2 months of 10-second granularity
# 6 months of 1-minute granularity
# 3 years of 10-minute granularity

# STANDARD GRAPHS
# retentions = 10:6h, 1m:7d, 1m:183d, 10m:3y
# 6 hours of 10-second granularity
# 1 week of 1-minute granularity
# 3 years of 10-minute granularity
#
# DEFAULT SCHEMA
#
#     [default]
#     priority = 0
#     pattern = .*
#     retentions = 1m:31d, 10m:1y
#
# Schema definitions for whisper files:
default[:graphite][:whisper][:schemas] = []


### WHISPER - DATABASE ENGINE
#
# Whisper must be installed as the same user that owns the python installation
# you will be using.  If you are using the default python that came with your
# distribution, or have no idea what this means, it is most likely the root /
# superuser account.
default[:graphite][:whisper][:dir]      = "whisper-#{graphite.version}"

### WEB - Django WEB APP
#
# This is the frontend / webapp that renders the images.
default[:graphite][:web][:dir]          = "graphite-web-#{graphite.version}"
#
# Set your local timezone (django will *try* to figure this out automatically)
default[:graphite][:web][:timezone]     = "Europe/London"
#
# This lists all the memcached servers that will be used by this webapp.
# If you have a cluster of webapps you want to make sure all of them
# have the *exact* same value for this setting. That will maximize cache
# efficiency. Setting MEMCACHE_HOSTS to be empty will turn off use of
# memcached entirely.
#
# You should not use the loopback address 127.0.0.1 here because every webapp in
# the cluster should use the exact same value and should list every member in the
# cluster.
default[:graphite][:web][:memcache_hosts]     = []


### METRICS - USER WHICH COLLECTS METRICS
#
# You can send metrics from within your Ruby/node.js/Python etc. app via
# the numerous clients (mostly statsd). Or, you can be hardcore and use
# something like awk to fetch data from e.g. redis and push it to your
# metrics collector or aggregator. This part is for hardcore users.
#
# Check the files/default/metrics/example.awk script for a dead simple redis
# collector.
#
# You shouldn't need to change this
default[:graphite][:metrics][:user] = "metrics"
#
# Define your metrics. Here's an example:

#     :graphite => {
#       :metrics => {
#         :files => [
#             {
#               :filename => "example.awk",
#               :command => %{
#                 while true; do
#                   redis-cli SMEMBERS your_key | gawk -f /home/metrics/example.awk
#                   sleep 20
#                 end
#               },
#               :cookbook => "graphite" # redundant, this is the default
#             }
#           ]
#         }
#     }
default[:graphite][:metrics][:files] = []
#
# The hostname where these metrics are being sent from.
# It should not contain . since carbon will create a directory for each
# component. your.awesome.hostname will result in
# <graphite-storage>your/awesome/hostname/metric.wsp
default[:graphite][:metrics][:hostname] = "your-hostname"
#
# Metrics collector/aggregator IP
default[:graphite][:metrics][:ip] = "127.0.0.1"
#
# Metrics collector/aggregator port
# If you're using statsd or statsite, this will be different
default[:graphite][:metrics][:port] = "2003"
