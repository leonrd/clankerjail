local _M = {}

function _M.parse_base_url(raw)
  local url = (raw or ""):gsub("^https?://", ""):gsub("/$", "")
  local domain, path = url:match("^([^/]+)(/.+)$")
  return domain or url, path or ""
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
