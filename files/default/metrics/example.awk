# Get the number of elements in a set and send them to statsite aggregator:
# redis-cli SMEMBERS your_key | gawk -f some.metric
#
# If you want to see the actual metrics send to the collector
# redis-cli SMEMBERS your_key | gawk -f some.metric -v metrics_cmd=1
# If you want to modify the key sent to the collecotr
# redis-cli SMEMBERS your_key | gawk -f some.metric -v metrics_cmd=1 -v key="custom_key"
#
################################# STATS

# pre-set some constants
#
BEGIN {
  PUSH = " | nc -u " ENVIRON["METRICS_IP"] " " ENVIRON["METRICS_PORT"]
  if (key != 0)
    KEY = key
  else
    KEY = "your_key"
}

END {
  # Might need tweaking based on your collector or aggregator
  # This example is for statsite and it will result in eg.
  #
  #     hostname.your_key:12|kv
  #
  metric = "echo \"" ENVIRON["HOSTNAME"] "." KEY ":" NR "|kv\""
  system(metric PUSH)

  # ~~~ debug
  if (metric_cmd == 1)
    print metric PUSH
}
