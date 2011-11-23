### GENERAL
#
default[:graphite][:src]     = "/usr/local/src/graphite"
default[:graphite][:home]    = "/opt/graphite"
default[:graphite][:version] = "0.9.9"
default[:graphite][:baseuri] = "http://launchpadlibrarian.net"



### CARBON - THE DATA AGGREGATOR
#
# By default, everything will be installed in /opt/graphite.
# It strongly recommended that you do not change the default install path.
# Strange problems can ensue if you do.
#
default[:graphite][:carbon][:dir]       = "carbon-#{graphite.version}"
default[:graphite][:carbon][:uri]       = "#{graphite.baseuri}/82112362/#{graphite.carbon.dir}.tar.gz"
default[:graphite][:carbon][:checksum]  = "c97d3bab6d60592daf5146dc1e2fb016"
default[:graphite][:carbon][:user]      = "graphite"
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
default[:graphite][:carbon][:line_receiver_port] = "2003"
#
# AMQP
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
# even 2 - 3 years worth of data. If you want to learn more about data
# retentions, please click here.

# Here is an example of the 13-month retention example (giving you a month of
# overlap when comparing metrics year-over-year):
# Note: Priority is not used. ** Rules are applied in the order they appear in
# the file**
#
#    [everything_1min_13months]
#    priority = 100
#    pattern = .*
#    retentions = 60:565920
#
# More info on data retention: http://graphite.wikidot.com/getting-your-data-into-graphite



### WHISPER - DATABASE ENGINE
#
# Whisper must be installed as the same user that owns the python installation
# you will be using.  If you are using the default python that came with your
# distribution, or have no idea what this means, it is most likely the root /
# superuser account.
default[:graphite][:whisper][:dir]      = "whisper-#{graphite.version}"
default[:graphite][:whisper][:uri]      = "#{graphite.baseuri}/82112367/#{graphite.whisper.dir}.tar.gz"
default[:graphite][:whisper][:checksum] = "66c05eafe8d86167909262dddc96c0bbfde199fa75524efa50c9ffbe9472078d"

### WEB - Django WEB APP
#
# This is the frontend / webapp that renders the images.
default[:graphite][:web][:dir]          = "graphite-web-#{graphite.version}"
default[:graphite][:web][:uri]          = "#{graphite.baseuri}/82112308/#{graphite.web.dir}.tar.gz"
default[:graphite][:web][:checksum]     = "6e8a6adc930c16f85c3442ce30f49a8f"
