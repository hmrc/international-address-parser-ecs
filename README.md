
# international-address-parser-ecs

This repo is for a building a docker image for parsing international addresses.

It wraps the `libpostal` and `pypostal` libraries behind an HTTP server with 3 POST endpoints, all of which take a `json` payload of the following form

```json
{
  "address": "..."
}
```


+ `/normalize` - this endpoint normalizes the given address.
    The output will like
  
```json
{
  "normalized": "..."
}
```

+ `/categorize` - this endpoint parses the given address and categories different components of the address.
    The output will be like
  
```json
{
  "categorized": {
    ...
  }
}
```

+ `/normalize-and-categorize` - this endpoint expands and then parses the given address - it is the same as calling `/normalize` and then `/categorize` with the output.
    The output will be like
  
```json
{
  "normalize-and-categorize": [
    {...},
    {...}
  }
}
```


### License

This code is open source software licensed under the [Apache 2.0 License]("http://www.apache.org/licenses/LICENSE-2.0.html").
