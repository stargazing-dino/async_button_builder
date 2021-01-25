## [2.0.0-dev.1] - 2021-01-25

Breaking. Replaces the fourth argument with a sealed union that better allows for directly managing states, removes unnecessary arguments such as padding, adds transition builders for custom transitions. Currently still includes AnimatedSize.

## [1.0.0-nullsafety.0] - 2021-01-12

Breaking. Adds a fourth argument of loading to the builder. This removes the value notifier that was difficult or confusing to manage in actual usage in my use cases. The argument isLoading is now a `bool`. This also adds a `disabled` field in order to set that on construction.

## [0.1.0-nullsafety.0] - 2021-01-12

Replaces the bool type of isLoading for a ValueNotifier<bool>.

## [0.0.1-nullsafety.2] - 2021-01-12

Adds analysis options and removes unnecessary typedef

## [0.0.1-nullsafety.1] - 2021-01-12

Adds docs to parameters and removes use of unnecessary undescore internal variables.

## [0.0.1-nullsafety.0] - 2021-01-11

Holds basic builder AsyncButtonBuilder. No tests yet. NNBD is supported
