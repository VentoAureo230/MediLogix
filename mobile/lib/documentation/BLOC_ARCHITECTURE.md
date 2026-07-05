# BLoC and Clean Architecture pattern

BLoC and Clean Architecture documentation.

## Structure

Here we use Clean Architecture in the project, so we have three main layers: Core, Features and Config. Each layer has its own responsibility and is independent from the others.

Core layer contains all the core functionalities of the app, such as constants, resources, usecases and util. This layer is independent from the features and can be used in any feature.

Config layer contains all the configuration of the app, such as routes and theme. This layer is independent from the features and can be used in any feature.

Features layer contains all the features of the app, such as `authentication`. Each feature has its own data, domain and presentation layers.

The `data layer` contains all the data sources, models and repository implementations.

> Data sources holds all the API calls, endpoints and parameeters. The actual queries are generated with Retrofit. A data source can be remote or local.
> Models extends the entities with JSON mapping and necessary methods for conversion.
> Repository implements all the methods described in the domain layer.

The `domain layer` contains all the entities, repository interfaces and usecases.

> Entites represent all the objects received.
> Repository declares all the methods.
> Usecases are "what does the feature do ?".

The `presentation layer` contains all the bloc (state management), pages and widgets.

> Bloc holds the bloc logic. It also holds Cubits.
> Pages holds the page if it is necessary to have a full page to display the feature.
> Widget are reusable tool or parts of the page.

```bash
.
├── config
│   ├── routes
│   └── theme
├── core
│   ├── constants
│   ├── resources
│   ├── usecases
│   └── util
├── features
│   └── daily_news
│       ├── data
│       │   ├── data_sources
│       │   │   ├── local
│       │   │   └── remote
│       │   ├── models
│       │   └── repository
│       ├── domain
│       │   ├── entities
│       │   ├── repository
│       │   └── usecases
│       └── presentation
│           ├── bloc
│           ├── pages
│           └── widget
└── injection_container.dart
└── main.dart
```
