# Sugar [![Build Status](https://travis-ci.org/slogsdon/sugar.png?branch=master)](https://travis-ci.org/slogsdon/sugar)

Web framework for Elixir

## Installation

Soon to come. Once Sugar has the basics, this section will be updated to reflect the steps needed to use Sugar in a project.

## Goals

- Speed. Sugar shouldn't be slow and neither should your project.
- Ease. Sugar should be simple because simple is easy to learn and use.
- Effective. Sugar should aid development. You have better things to which to devote your time.

## Reason for Existence

Why build this when [Dynamo](https://github.com/dynamo/dynamo) and [Weber](http://0xax.github.io/weber/) exist with growing communities? While both projects are great in their own right, Sugar aims to be another contender, sparking more development on all three projects (and/or others that may follow) and giving developers another option when deciding what framework fits their needs best. Sugar may even strive to shake things up just as [ChicagoBoss](http://www.chicagoboss.org/) has done.

## Tentative DSL for routing

```elixir
defmodule MySugar.Routes do
  use Sugar.Router

  # get, post, put, delete, and any will be supported
  get "/", controller: Application, action: :index
  get "/login", controller: Session, action: :show_login
  post "/login", contorller: Session, action: :handle_login

end
```

## License

See [LICENSE](https://github.com/slogsdon/sugar/blob/master/LICENSE).