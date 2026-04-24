local _M = {}

function _M.parse_url(url)

  url = (url or ""):match('^"?(.-)"?$')

  if not url or url == "" then
    return nil, "empty url"
  end

  local result = {}

  -- Extract scheme
  local scheme, rest = url:match("^([a-zA-Z][a-zA-Z0-9+%-.]*)://(.+)$")
  if scheme then
    result.scheme = scheme:lower()
  else
    rest = url
  end

  -- Extract fragment (drop it)
  rest = rest:match("^([^#]*)") or rest

  -- Split authority (host+port) from path+query
  local authority, path_and_query
  if rest:sub(1,1) == "/" then
    -- No authority (e.g. relative URL or path-only)
    authority = nil
    path_and_query = rest
  else
    authority, path_and_query = rest:match("^([^/]+)(/.*)$")
    if not authority then
      -- No path at all
      authority = rest
      path_and_query = "/"
    end
  end

    -- Extract host and port from authority
    if authority then
      -- Handle IPv6 addresses like [::1]:8080
      local ipv6, port = authority:match("^%[([^%]]+)%]:(%d+)$")
      if ipv6 then
        result.host = ipv6
        result.port = tonumber(port)
      else
        ipv6 = authority:match("^%[([^%]]+)%]$")
        if ipv6 then
          result.host = ipv6
        else
          local host, port_str = authority:match("^([^:]+):(%d+)$")
          if host then
            result.host = host
            result.port = tonumber(port_str)
          else
            result.host = authority
          end
        end
      end
    end

    -- Default port from scheme if not explicit
    if not result.port and result.scheme then
      local default_ports = { http = 80, https = 443, ftp = 21, ws = 80, wss = 443 }
      result.port = default_ports[result.scheme]
    end

    -- Split path prefix from query string
    if path_and_query then
      local path, query = path_and_query:match("^([^?]*)(?.*)$")
      -- ^([^?]*) captures everything before '?', then (\?.*) captures '?' onward
      path, query = path_and_query:match("^([^?]*)(%?.*)$")
      if path then
        result.path   = path ~= "" and path or "/"
        result.query  = query  -- includes the leading '?'
      else
        result.path  = path_and_query ~= "" and path_and_query or "/"
        result.query = nil
      end
    else
      result.path = "/"
    end

    result.host_and_port = result.host .. (result.port and (":" .. result.port) or "")
    result.path_and_query = result.path .. (result.query or "")

    return result
end

function _M.env(name)
  local v = os.getenv(name)
  return (v and v ~= "") and v or nil
end

function _M.rewrite_path_prefix(src_prefix, dst_prefix)
  local suffix = ngx.var.uri:sub(#src_prefix + 1)

  -- Ensure leading slash
  if suffix == "" or suffix:sub(1,1) ~= "/" then
    suffix = "/" .. suffix
  end

  -- Prevent path traversal (../)
  if suffix:find("%.%./") or suffix:find("/%.%.") then
    ngx.exit(ngx.HTTP_BAD_REQUEST)
  end

  ngx.req.set_uri(dst_prefix .. suffix, false)

  -- Preserve query string explicitly (set_uri clears it)
  local args = ngx.var.args
  if args and args ~= "" then
    ngx.req.set_uri_args(args)
  end
end

return _M
