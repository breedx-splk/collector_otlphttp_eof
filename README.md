# Collector OTLPHTTP EOF repro

Repro repo for a collector bug/regression related to otlphttp EOF

# About

There exists a regression/bug in 0.81.0 (and 82 and 83) of the `otel-collector-contrib`
with the otlphttp exporter. This bug is initially observed when debug logging for
trace export is enabled:

```
{"kind": "exporter", "data_type": "traces", "name": "logging/debug"}
2023-08-22T15:36:59.784-0700	info	exporterhelper/queued_retry.go:423	Exporting failed. Will retry the request after interval.	{"kind": "exporter", "data_type": "traces", "name": "otlphttp", "error": "unexpected EOF", "interval": "7.214643193s"}
```

The collector has sent a successful `otlphttp` payload to a backend and received an HTTP 200
success response, but fails to parse the return body and thus unnecessarily re-queues
the data for retransmission.

The result is both a confusing error message to the user and a duplicate sending
of payload data to the backend. This wastes resources and could potentially cause 
other larger problems for backends.

It is believed that the root cause was introduced when the partial success
behavior was added in 0.81.0. This assumes that a response payload from the backend
always contains protobuf, which is not necessarily true. In this repro case, 
the response is clearly json.

# Reproduce

To reproduce, first clone this repo and then open 3 terminal windows. 
In the first one, run the fake backend like this:

```
npm install
npm run backend
```

This fake backend server returns HTTP 200 for any POST to `/`, and it returns
a hard-coded json response.


Then run the collector in the second window like this:
```
./collector.sh
```

Then send a trace to the collector like this:

```
curl -i -X POST -H 'content-type: application/json' --data @trace.json http://localhost:4318/v1/traces
```

# Results

Note the error in the collector output similar to the above. You will also
notice after a delay that the collector is attempting to resend the payload.