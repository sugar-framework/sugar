### v0.4.0-dev

- [Enhancement] Add view layer with EEx, DTL, and Haml engines
- [Dependency] Add [sugar-framework/templates](https://github.com/sugar-framework/templates) back in
- [Breaking] Change `Sugar.Controller.render/3` to [`Sugar.Controller.render/4`](http://sugar-framework.github.io/docs/api/sugar/Sugar.Controller.html#render/4)
- [Enhancement] Add mix.lock from repository to improve dependency management in projects per @ericmj's recommendation
- [Enhancement] Add [`Sugar.Controller.static/2`](http://sugar-framework.github.io/docs/api/sugar/Sugar.Controller.html#static/2)
- [Enhancement] Add development exceptions screen for debugging

### [v0.3.0](https://github.com/sugar-framework/sugar/tree/v0.3.0) - 15 May 2014

- [Enhancement] Upgrade to Elixir v0.13.2
- [Dependency] Add [sugar-framework/plugs](https://github.com/sugar-framework/plugs) back in
- [Enhancement] Remove mix.lock from repository to improve dependency management in projects
- [Enhancement] Add Unit tests to increase coverage from ~5% to ~96%
- [Enhancement] Add Controller hooks for before/after actions
- [Enhancement] Add Router filters for before/after calling matched route

### [v0.2.0](https://github.com/sugar-framework/sugar/tree/v0.2.0) - 13 Feb 2014

- [Enhancement] Resource routing
- [Enhancement] Return helpers
    - JSON
    - Raw
    - Default 404

### [v0.1.0](https://github.com/sugar-framework/sugar/tree/v0.1.0) - 07 Feb 2014

- [Enhancement] Integrate Plug
- [Enhancement] Routing
    - Basic routing
    - Ensure guards are passed to `Plug.Router`
- [Enhancement] Basic responses
- [Enhancement] Mimetypes in responses
- [Enhancement] Userland Configuration
