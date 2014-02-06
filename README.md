# Sugar [![Build Status](https://travis-ci.org/slogsdon/sugar.png?branch=master)](https://travis-ci.org/slogsdon/sugar)

Web framework for Elixir

## Goals

- Speed. Sugar shouldn't be slow and neither should your project.
- Ease. Sugar should be simple because simple is easy to learn and use.
- Effective. Sugar should aid development. You have better things to which to devote your time.

## Reason for Existence

Why build this when [Dynamo](https://github.com/dynamo/dynamo), [Weber](http://0xax.github.io/weber/), and [Phoenix](https://github.com/phoenixframework/phoenix) exist with growing communities? While both projects are great in their own right, Sugar aims to be another contender, sparking more development on all three projects (and/or others that may follow) and giving developers another option when deciding what framework fits their needs best. Sugar may even strive to shake things up just as [ChicagoBoss](http://www.chicagoboss.org/) has done.

## Getting Started

Soon to come. Once Sugar has the basics, this section will be updated to reflect the steps needed to use Sugar in a project.

## Routing

Because Sugar builds upon [Plug](https://github.com/elixir-lang/plug), it leverages `Plug.Router` to do the heavy lifting in routing your application, adding an alternate DSL.

### DSL Example

```elixir
defmodule MySugar.Routes do
  use Sugar.Router

  get "/", Application, :index
  get "/login", Session, :show_login
  post "/login", Session, :handle_login

end
```

## Who's behind this?

Why, the [contributors](https://github.com/slogsdon/sugar/graphs/contributors), of course! Would you consider being one? Please send a pull request :)

## How to start contributing

The main product of this repository is the example terms in the file [CONTRIBUTING.md](https://github.com.slogsdon/sugar/blob/master/CONTRIBUTING>md). This project uses those guidelines as the basis for its own development process. Please refer to that file.

## License

See [LICENSE](https://github.com/slogsdon/sugar/blob/master/LICENSE).