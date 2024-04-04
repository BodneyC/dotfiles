local function add_to_path(p, sa)
  if not package[p] or type(package[p]) ~= "string" then
    error(p .. " not found in package")
  end
  for _, s in ipairs(sa) do
    package[p] = package[p] .. ";" .. tostring(s)
  end
end

local version = _VERSION:gsub("Lua ", "")
local home = os.getenv("HOME")

add_to_path("path", {
  -- '/root/.luarocks/share/lua/' .. version .. '/?.lua',
  -- '/root/.luarocks/share/lua/' .. version .. '/?/init.lua',
  home
  .. "/.local/share/lua/"
  .. version
  .. "/?.lua",
  home .. "/.local/share/lua/" .. version .. "/?/init.lua",
})

add_to_path("cpath", {
  -- '/root/.luarocks/lib/lua/' .. version .. '/?.so',
  home
  .. "/.local/lib/lua/"
  .. version
  .. "/?.so",
})
