defrecord Sugar.Template,
  key: nil,
  filename: nil,
  engine: nil,
  updated_at: nil do
  @moduledoc """
  The template record is responsible to keep information about
  templates to be compiled and rendered. It contains:

  - `:key` - The key used to find the template
  - `:filename` - The filename of the template
  - `:engine` - The template engine responsible for compiling the 
    template
  - `:updated_at` - The last time the template was updated
  """

  @type key        :: atom
  @type filename   :: iodata
  @type engine     :: module
  @type year       :: non_neg_integer
  @type month      :: non_neg_integer
  @type day        :: non_neg_integer
  @type hour       :: non_neg_integer
  @type minute     :: non_neg_integer
  @type second     :: non_neg_integer
  @type datetime   :: {{ year, month, day }, { hour, minute, second }}
  @type updated_at :: datetime

  record_type key: key,
              filename: filename,
              engine: engine,
              updated_at: updated_at
end

defmodule Sugar.Templates do
  
end