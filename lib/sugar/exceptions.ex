# Sugar's Dev Exception screen is based off of Phalcon's Debug screen.
# Below is the original license and header for the corresponding file
# in the cphalcon project:
#
# License:
#
# New BSD License
#
# Copyright (c) 2011-2014, Phalcon Framework Team
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the <organization> nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# Header:
# +------------------------------------------------------------------------+
# | Phalcon Framework                                                      |
# +------------------------------------------------------------------------+
# | Copyright (c) 2011-2014 Phalcon Team (http://www.phalconphp.com)       |
# +------------------------------------------------------------------------+
# | This source file is subject to the New BSD License that is bundled     |
# | with this package in the file docs/LICENSE.txt.                        |
# |                                                                        |
# | If you did not receive a copy of the license and are unable to         |
# | obtain it through the world-wide-web, please send an email             |
# | to license@phalconphp.com so we can send you a copy immediately.       |
# +------------------------------------------------------------------------+
# | Authors: Andres Gutierrez <andres@phalconphp.com>                      |
# | Eduar Carvajal <eduar@phalconphp.com>                                  |
# +------------------------------------------------------------------------+

defmodule Sugar.Exceptions do
  def dev_template do
    """
    <!doctype html>
    <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
      <link rel="shortcut icon" href="http://sugar-framework.github.io/assets/img/sugar_logo.png"></link>
      <title><%= @kind %>: <%= if is_atom(@kind) do %><%= inspect(@value) %><% else %><%= @value.message %><% end %></title>
      <link href="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/themes/smoothness/jquery-ui.css" type="text/css" rel="stylesheet" />
      <style type="text/css">
        @import url(http://fonts.googleapis.com/css?family=Open+Sans);
        body { font-family: "Open Sans", Helvetica, Arial, sans-serif; margin: 0 }
        .str,.atv { color: #acd7c5 }
        .kwd { color: #717171 }
        .com { color: #66747B }
        .typ,.tag { color: silver }
        .lit { color: #5AB889 }
        .pun { color: #dadada }
        .pln { color: #F1F2F3 }
        .atn { color: #E0E2E4 }
        .dec { color: purple }
        pre.prettyprint { font-family: Consolas,Lucida Console,Monaco,Andale Mono,"MS Gothic",monospace; border: 0 solid #888; font-size: 13px; font-weight: 400 }
        ol.linenums { margin-top: 0; margin-bottom: 0 }
        .prettyprint { background-color: #2f2f2f }
        li.L0,li.L1,li.L2,li.L3,li.L4,li.L5,li.L6,li.L7,li.L8,li.L9 { color: #555; list-style-type: decimal }
        li.L1,li.L3,li.L5,li.L7,li.L9 { background: #2a2a2a }
        li.highlight { background: #1a1a1a }
        .error-main { background: #066; color: #fff; border-radius: 3px; font-size: 14px; width: 90%; text-align: left; padding: 14px 10px 10px }
        .error-main h1 { font-family: "Open Sans", Helvetica, Arial, sans-serif; font-size: 18px; text-shadow: 1px 0 #111; font-weight: 400; margin: 0 }
        .error-scroll { height: 250px; overflow-y: scroll }
        .error-info h3 { color: #414141; font-size: 14px; border-bottom: 1px solid #eaeaea; margin: 0 0 5px }
        .error-info { text-align: center; width: 90%; background: #fff; margin-top: 5px; padding: 10px }
        .error-info td { color: #373536; font-size: 12px; padding: 3px }
        .error-info a { color: #373536; text-decoration: none }
        .error-info a: hover { text-decoration: underline }
        .error-info td.error-number { color: #807B70; width: 20px; font-size: 14px }
        .error-info .error-file,.error-main .error-file { font-size: 11px; margin-top: 3px; color: #717171 }
        .error-info .error-file { background: #066; color: #fff; padding-top: 10px; padding-bottom: 7px; padding-left: 5px; max-width: 1024px; margin: 10px 0 0 }
        .error-main .error-file { color: #fafafa }
        .error-info .error-class { color: #2A2A2A }
        .error-info .error-parameter { color: #807B70 }
        .error-info .error-function { color: #333; font-weight: 700 }
        .error-info pre { text-align: left; max-width: 1024px; margin: 0 }
        .version { font-family: sans-serif; text-align: right; color: #fff; background: #333; font-size: 12px; margin-bottom: 10px; padding: 10px }
        .version a { color: #fff }
        .superglobal-detail { width: 70% }
        .superglobal-detail th { background: #066; color: #fff; font-size: 13px; padding: 4px }
        .superglobal-detail td { border-bottom: 1px solid #dadada; padding: 3px }
        .superglobal-detail td.key { font-weight: 700 }
        .ui-widget { font-family: Helvetica, Arial, sans-serif }
        .ui-tabs .ui-tabs-nav a { font-size: 13px }
      </style>
    </head>
    <body>
      <div class="version">Sugar Framework <a target="_new" href="https://github.com/sugar-framework/sugar">0.4.0-dev</a></div>
      <div align="center">
        <div class="error-main">
          <h1><%= @kind %>: <%= if is_atom(@kind) do %><%= inspect(@value) %><% else %><%= @value.message %><% end %></h1>
          <% file = @stacktrace |> hd %>
          <span class="error-file"><%= file[:file] %> (<%= file[:line] %>)</span>
        </div>
        <div class="error-info">
          <div id="tabs">
            <ul>
              <li><a href="#error-tabs-1">Stacktrace</a></li>
              <li><a href="#error-tabs-2">Plug.Conn</a></li>
              <li><a href="#error-tabs-3">ENV Variables</a></li>
              <li><a href="#error-tabs-4">Elixir Information</a></li>
            </ul>
            <div id="error-tabs-1">
              <table cellspacing="0" align="center" width="100%">
                <script>var i = 0;</script>
                <%= for st <- @stacktrace do %>
                  <tr>
                    <td align="right" valign="top" class="error-number">#<script>document.write(i);i++;</script></td>
                    <td align="left">
                      <span class="error-class"><%= st[:module] %></span>.<span class="error-function"><%= st[:function] %></span>/<span class="error-arrity"><%= st[:arrity] %></span>
                      <br/>
                      <div class="error-file" align="center">
                        <%= st[:file] %> (<%= st[:line] %>)
                      </div>
                      <pre class='prettyprint highlight:1:<%= st[:line] %>"> linenums error-scroll'><%= st[:source] %></pre>
                    </td>
                  </tr>
                <% end %>
              </table>
            </div>
            <div id="error-tabs-2">
              <table cellspacing="0" align="center" class="superglobal-detail">
                <tr>
                  <th>Key</th>
                  <th>Value</th>
                </tr>
                <tr>
                  <td class="key">adapter</td>
                  <td><%= inspect(@conn.adapter) %></td>
                </tr>
                <tr>
                  <td class="key">assigns</td>
                  <td><%= inspect(@conn.assigns) %></td>
                </tr>
                <tr>
                  <td class="key">before_send</td>
                  <td><%= inspect(@conn.before_send) %></td>
                </tr>
                <tr>
                  <td class="key">cookies</td>
                  <td><%= inspect(@conn.cookies) %></td>
                </tr>
                <tr>
                  <td class="key">host</td>
                  <td><%= inspect(@conn.host) %></td>
                </tr>
                <tr>
                  <td class="key">method</td>
                  <td><%= inspect(@conn.method) %></td>
                </tr>
                <tr>
                  <td class="key">params</td>
                  <td><%= inspect(@conn.params) %></td>
                </tr>
                <tr>
                  <td class="key">path_info</td>
                  <td><%= inspect(@conn.path_info) %></td>
                </tr>
                <tr>
                  <td class="key">port</td>
                  <td><%= inspect(@conn.port) %></td>
                </tr>
                <tr>
                  <td class="key">private</td>
                  <td><%= inspect(@conn.private) %></td>
                </tr>
                <tr>
                  <td class="key">query_string</td>
                  <td><%= inspect(@conn.query_string) %></td>
                </tr>
                <tr>
                  <td class="key">req_cookies</td>
                  <td><%= inspect(@conn.req_cookies) %></td>
                </tr>
                <tr>
                  <td class="key">req_headers</td>
                  <td>
                    <table cellspacing="0" align="center" class="superglobal-detail">
                      <%= for {header, value} <- @conn.req_headers do %>
                        <tr>
                          <td class="key"><%= header %></td>
                          <td><%= value %></td>
                        </tr>
                      <% end %>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td class="key">resp_body</td>
                  <td><%= inspect(@conn.resp_body) %></td>
                </tr>
                <tr>
                  <td class="key">resp_cookies</td>
                  <td><%= inspect(@conn.resp_cookies) %></td>
                </tr>
                <tr>
                  <td class="key">resp_headers</td>
                  <td><%= inspect(@conn.resp_headers) %></td>
                </tr>
                <tr>
                  <td class="key">scheme</td>
                  <td><%= inspect(@conn.scheme) %></td>
                </tr>
                <tr>
                  <td class="key">script_name</td>
                  <td><%= inspect(@conn.script_name) %></td>
                </tr>
                <tr>
                  <td class="key">state</td>
                  <td><%= inspect(@conn.state) %></td>
                </tr>
                <tr>
                  <td class="key">status</td>
                  <td><%= inspect(@conn.status) %></td>
                </tr>
              </table>
            </div>
            <div id="error-tabs-3">
              <table cellspacing="0" align="center" class="superglobal-detail">
                <tr>
                  <th>Key</th>
                  <th>Value</th>
                </tr>
                <%= for var <- @env do %>
                  <tr>
                    <td class="key"><%= var[:key] %></td>
                    <td><%= var[:value] %></td>
                  </tr>
                <% end %>
              </table>
            </div>
            <div id="error-tabs-4">
              <table cellspacing="0" align="center" class="superglobal-detail">
                <tr>
                  <td>Version</td>
                  <td><%= @elixir_build_info[:version] %></td>
                </tr>
                <tr>
                  <td>Tag</td>
                  <td><%= @elixir_build_info[:tag] %></td>
                </tr>
                <tr>
                  <td>Build Date</td>
                  <td><%= @elixir_build_info[:date] %></td>
                </tr>
              </table>
            </div>
          </div>
          <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
          <script type="text/javascript" src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.4/jquery-ui.min.js"></script>
          <script type="text/javascript" src="//static.phalconphp.com/debug/1.2.0/jquery/jquery.scrollTo.js"></script>
          <script type="text/javascript" src="//static.phalconphp.com/debug/1.2.0/prettify/prettify.js"></script>
          <script type="text/javascript" src="//static.phalconphp.com/debug/1.2.0/pretty.js"></script>
        </div>
      </div>
    </body>
    </html>
    """
  end
end
