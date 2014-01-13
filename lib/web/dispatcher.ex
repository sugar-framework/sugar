defmodule Web.Dispatcher do
  def dispatch do
    [
      _HostMatch1: [
        #path match 1
        {
          '/[...]',           # path
          Web.Handler.Request,# handler
          []                  # opts
        }
      ]
    ]
  end
end