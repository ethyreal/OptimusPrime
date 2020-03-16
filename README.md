# OptimusPrime

State Management / Composable Architecture excerise app based on the [PointFree](https://www.pointfree.co) video series on the subject.

## Setup

The API needs a token to authenticate with the WolframAlpha service.  This can be generated in the for free from the developer section of the [WolframAlpha](http://products.wolframalpha.com/api/) site.

OptimusPrime expects a configuration file to be bundled framework (this may change later.. but is fine for now).  It should be located here:

`Configuration/optimusprime_configuration.json`

There is an example file that can be edited, just rename that bad boy from ye ol'shell like so:

```sh
mv Configuration/optimusprime_configuration_example.json Configuration/optimusprime_configuration.json
```

