# CoReMite - Console Reporter For Mite

CoReMite is a small ruby script / reporting tool which queries the RSS api of the online time tracking tool [mite](http://mite.yo.lk). The returned data is processed and printed to the console.

## Setup

You have to create a **config.yaml** (see [config-sample.yaml](./config-sample.yaml)) which includes the name of your mite account ( **MITE_ACCOUNT** ) and the access key ( **MITE_KEY** ) of a user who has the right to query the desired data. Furthermore you need to create a list of users including their mite user ids, to define which users should be tracked. Both, the access key and the user ids, can be found in the RSS urls that can be generated on the reporting page in the [mite webfrontend](https://yourmiteaccount.mite.yo.lk/reports/time_entries).

## Limitations

* I only tested this script with ruby 1.9.3 and 2.0.0. It definitely won't work with 1.8.x!

## Copyright

Copyright (c) 2013 by [Christopher de Bruin](https://github.com/chrisdb)
See [LICENSE](./LICENSE) for details.