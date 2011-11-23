# ABOUT

* Store numeric time-series data
* Render graphs of this data on demand

Graphite is an enterprise-scale monitoring tool that runs well on cheap
hardware. It was originally designed and written by Chris Davis at
Orbitz in 2006 as side project that ultimately grew to be a foundational
monitoring tool. In 2008, Orbitz allowed Graphite to be released under
the open source Apache 2.0 license. Since then Chris has continued to
work on Graphite and has deployed it at other companies including Sears,
where it serves as a pillar of the e-commerce monitoring system. Today
many large companies use it.

What Graphite does not do is collect data for you, however there are
some tools out there that know how to send data to graphite. Even though
it often requires a little code, sending data to Graphite is very
simple.

Feeding in your data is pretty easy, typically most of the effort is in
collecting the data to begin with. As you send datapoints to Carbon,
they become immediately available for graphing in the webapp. The webapp
offers several ways to create and display graphs including a simple URL
API that makes it easy to embed graphs in other webpages.



# COMPONENTS

Graphite consists of 3 software components:


## CARBON

A Twisted daemon that listens for time-series data.

Data collection agents connect to carbon and send their data, and
carbon's job is to make that data available for real-time graphing
immediately and try to get it stored on disk as fast as possible.

Carbon is made of up three processes:

* carbon-agent.py
* carbon-cache.py
* carbon-persister.py

The primary process is carbon-agent.py, which starts up the other two
processes in a pipeline. Carbon-agent accepts connections and receives
time series data in the appropriate format.  This data is sent through
the pipeline to carbon-cache, who stores the data a cache where data
points are grouped by their associated metric.  Carbon-cache constantly
attempts to write the largest such group of data points down the
pipeline to carbon-persister. Carbon-persister reads these data points
and writes them to disk using whisper.

The reason carbon is split into three processes is actually because of
Python's threading problems. Originally carbon was a single application
where these distinct functions were performed by threads, but alas
Python's GIL prevents multiple threads from actually running
concurrently. Since the initial deployment of Graphite was done on a
machine with lots of rather slow CPU's, we needed true concurrency for
performance reasons. Thus it was split into three processes connected
via pipes.


## WHISPER

Whisper is a fixed-size database, similar in design to RRD
(round-robin-database). It provides fast, reliable storage of numeric
data over time.

RRD is great, and initially Graphite did use RRD for storage. Over time
though, we ran into several issues inherent to RRD's design.

* RRD can't take updates for a timestamp prior to its most recent
  update. So for example, if you miss an update for some reason you
have no simple way of back-filling your RRD file by telling rrdtool to
apply an update to the past. Whisper does not have this limitation, and
this makes importing historical data into Graphite way way easier.
* At the time whisper was written, RRD did not support compacting
  multiple updates into a single operation. This feature is critical to
Graphite's scalability.
* RRD doesn't like irregular updates. If you update an RRD but don't
  follow up another update soon, your original update will be lost. This
is the straw that broke the camel's back, since Graphite is used for
various operational metrics, some of which do not occur regularly
(randomly occuring errors for instance) we started to notice that
Graphite sometimes wouldn't display data points which we knew existed
because we'd received alarms on them from other tools. The problem
turned out to be that RRD was dropping the data points because they were
irregular. Whisper had to be written to ensure that all data was
reliably stored and accessible.


## WEBAPP

A Django webapp that renders graphs on-demand using Cairo.

Upon receiving a rendering request, the Graphite webapp simultaneously
retrieves data for the requested metrics from the disk and from carbon's
cache via a simple cache query socket that carbon-cache provides.
Graphite then combines these two sources of data points into a single
series, which is then rendered. This ensures that graphs are always
real-time, even when the data hasn't been written to disk yet.
