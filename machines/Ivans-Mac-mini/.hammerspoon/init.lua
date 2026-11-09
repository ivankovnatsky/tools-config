hs.window.animationDuration = 0
hs.window.setShadows(false)

ext = {
  frame = {},
  win = {},
  app = {},
  utils = {},
  cache = {},
  watchers = {},
}

local mash = { "alt" }

hs.fnutils.each({
  { key = "1", app = "Finder" },
  { key = "2", app = "Muxy" },
  { key = "3", app = "Firefox Developer Edition" },
  { key = "4", app = "Cursor" },
  { key = "9", app = "System Settings" }
}, function(object)
  hs.hotkey.bind(mash, object.key, function()
    local appToLaunch = object.app

    ext.app.forceLaunchOrFocus(appToLaunch)
  end)
end)

-- https://github.com/szymonkaliski/Dotfiles/blob/b5a640336efc9fde1e8048c2894529427746076f/Dotfiles/hammerspoon/init.lua#L411-L440
function ext.app.forceLaunchOrFocus(appName)
  -- first focus with hammerspoon
  hs.application.launchOrFocus(appName)

  -- clear timer if exists
  if ext.cache.launchTimer then
    ext.cache.launchTimer:stop()
  end

  -- wait 500ms for window to appear and try hard to show the window
  ext.cache.launchTimer = hs.timer.doAfter(0.5, function()
    local frontmostApp = hs.application.frontmostApplication()
    local frontmostWindows = hs.fnutils.filter(frontmostApp:allWindows(), function(win)
      return win:isStandard()
    end)

    -- break if this app is not frontmost (when/why?)
    if frontmostApp:title() ~= appName then
      print("Expected app in front: " .. appName .. " got: " .. frontmostApp:title())
      return
    end

    if #frontmostWindows == 0 then
      -- check if there's app name in window menu (Calendar, Messages, etc...)
      if frontmostApp:findMenuItem({ "Window", appName }) then
        -- select it, usually moves to space with this window
        frontmostApp:selectMenuItem({ "Window", appName })
      else
        -- otherwise send cmd-n to create new window
        hs.eventtap.keyStroke({ "cmd" }, "n")
      end
    end
  end)
end

function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

-- Quake-style kitty quick terminal (F12) - disabled
-- hs.hotkey.bind({}, "F12", function()
--   hs.execute("/opt/homebrew/bin/kitten quick-access-terminal", true)
-- end)


-- Private-use codepoints (Nerd Font icons) render in HackNFP-Regular;
-- everything else in the menu bar font.
function ext.utils.menuTitle(text)
  local base = hs.styledtext.defaultFonts.menuBar
  local styles = {
    [false] = { font = base, baselineOffset = -1 },
    [true] = {
      font = { name = "HackNFP-Regular", size = base.size },
      baselineOffset = -1,
    },
  }
  local out, run, runIcon = nil, {}, false
  local function flush()
    if #run > 0 then
      local piece = hs.styledtext.new(table.concat(run), styles[runIcon])
      out = out and out .. piece or piece
      run = {}
    end
  end
  for _, c in utf8.codes(text) do
    local isIcon = (c >= 0xE000 and c <= 0xF8FF) or c >= 0xF0000
    if isIcon ~= runIcon then
      flush()
      runIcon = isIcon
    end
    table.insert(run, utf8.char(c))
  end
  flush()
  return out or hs.styledtext.new("", styles[false])
end

ext.cache.bar = { menu = hs.menubar.new(true, "hammerspoon"), seg = {}, refresh = {} }

function ext.app.barSet(name, order, title, tooltip)
  local b = ext.cache.bar
  b.seg[name] = { order = order, title = title, tip = tooltip }
  local list = {}
  for _, v in pairs(b.seg) do
    table.insert(list, v)
  end
  table.sort(list, function(x, y) return x.order < y.order end)
  local titles, tips = {}, {}
  for _, v in ipairs(list) do
    table.insert(titles, v.title)
    if v.tip then
      table.insert(tips, v.tip)
    end
  end
  b.menu:setTitle(ext.utils.menuTitle(table.concat(titles, "   ")))
  b.menu:setTooltip(table.concat(tips, "\n"))
end

function ext.app.barOnClick(fn)
  table.insert(ext.cache.bar.refresh, fn)
end

ext.cache.bar.menu:setClickCallback(function()
  for _, fn in ipairs(ext.cache.bar.refresh) do
    fn()
  end
end)

if not hs.application.get("com.amethyst.Amethyst") then
  hs.application.launchOrFocusByBundleID("com.amethyst.Amethyst")
end

ext.cache.sys = {
  cpu = "–",
  mem = "–",
  temp = "–",
  disk = "–",
  extra = {},
  extraDisks = {
    { icon = "\u{F01BC}", path = "${externalVolume}" }
  },
}

local function pct(x)
  return math.floor(x + 0.5) .. "%"
end

local function volumePct(path)
  local v = hs.fs.volume.allVolumes()[path]
  if not v or not v.NSURLVolumeTotalCapacityKey or v.NSURLVolumeTotalCapacityKey == 0 then
    return "–"
  end
  local total = v.NSURLVolumeTotalCapacityKey
  return pct((total - (v.NSURLVolumeAvailableCapacityKey or 0)) / total * 100)
end

local function cpuPct()
  local t = hs.host.cpuUsageTicks().overall
  local busy = t.user + t.system + t.nice
  local all = busy + t.idle
  local prev = ext.cache.sys.cpuPrev
  ext.cache.sys.cpuPrev = { busy = busy, all = all }
  if not prev or all == prev.all then
    return "–"
  end
  return pct((busy - prev.busy) / (all - prev.all) * 100)
end

-- Activity Monitor's Physical Memory, Memory Used, Cached Files, Swap Used.
local function memStats()
  local v = hs.host.vmStat()
  local function gb(bytes)
    return string.format("%.1fGB", bytes / 2^30)
  end
  local cached = (v.fileBackedPages + v.pagesPurgeable) * v.pageSize
  local free = (v.pagesFree + v.pagesSpeculative) * v.pageSize
  local used = v.memSize - cached - free
  local swap = tonumber(hs.execute("/usr/sbin/sysctl -n vm.swapusage"):match("used = ([%d.]+)M"))
  return table.concat({ gb(v.memSize), gb(used), gb(cached), swap and gb(swap * 2^20) or "–" }, ", ")
end

function ext.app.updateSysDisks()
  local s = ext.cache.sys
  s.disk = volumePct("/")
  for i, d in ipairs(s.extraDisks) do
    s.extra[i] = volumePct(d.path)
  end
end

local function renderSysStats()
  local s = ext.cache.sys
  -- Nerd Font: oct-cpu, fa-thermometer_half, fa-memory, md-harddisk.
  local items = {
    { "\u{F4BC}", s.cpu }, { "\u{F2C9}", s.temp }, { "\u{EFC5}", s.mem }, { "\u{F02CA}", s.disk },
  }
  local tips = { "CPU", "Temp (max of CPU/GPU)", "Memory", "Disk" }
  for i, d in ipairs(s.extraDisks) do
    table.insert(items, { d.icon, s.extra[i] or "–" })
    table.insert(tips, d.path)
  end
  local parts = {}
  for _, it in ipairs(items) do
    table.insert(parts, it[1] .. " " .. it[2])
  end
  ext.app.barSet("sysstats", 20, table.concat(parts, "  "), table.concat(tips, " · "))
end

-- macmon samples for ~0.5s, so run it async and re-render on exit.
local function updateTemp()
  local s = ext.cache.sys
  if s.tempTask and s.tempTask:isRunning() then
    return
  end
  s.tempTask = hs.task.new("/opt/homebrew/bin/macmon", function(code, out)
    local ok, data = pcall(hs.json.decode, out or "")
    local temps = code == 0 and ok and type(data) == "table" and type(data.temp) == "table" and data.temp or {}
    local t
    for _, v in ipairs({ temps.cpu_temp_avg, temps.gpu_temp_avg }) do
      if type(v) == "number" and (not t or v > t) then
        t = v
      end
    end
    s.temp = t and (math.floor(t + 0.5) .. "°") or "–"
    renderSysStats()
  end, { "pipe", "-s", "1", "-i", "500" })
  if not (s.tempTask and s.tempTask:start()) then
    s.temp = "–"
  end
end

function ext.app.updateSysStats()
  local s = ext.cache.sys
  s.cpu = cpuPct()
  s.mem = memStats()
  renderSysStats()
  updateTemp()
end

ext.app.barOnClick(ext.app.updateSysStats)
ext.app.updateSysDisks()
ext.app.updateSysStats()
ext.cache.sysTimer = hs.timer.doEvery(20, ext.app.updateSysStats)
ext.cache.sysDiskTimer = hs.timer.doEvery(600, ext.app.updateSysDisks)

ext.app.barSet("battery", 30, "🔋…")

function ext.app.updateBatterySoc()
  hs.http.asyncGet("http://127.0.0.1:8787/soc", nil, function(status, body)
    if status ~= 200 then
      ext.app.barSet("battery", 30, "🔋?",
        "battery-monitoring unreachable (HTTP " .. tostring(status) .. ")")
      return
    end
    local ok, data = pcall(hs.json.decode, body)
    local dev = nil
    if ok and type(data) == "table" then
      if data.soc ~= nil then
        dev = data
      else
        for _, d in ipairs(data) do
          if d.primary then
            dev = d
            break
          end
        end
      end
    end
    if not dev or dev.soc == nil then
      ext.app.barSet("battery", 30, "🔋?", "no primary device reading")
      return
    end
    local st = type(dev.status) == "table" and dev.status or {}
    local outW = tonumber(st.output_power_total) or tonumber(dev.ac_w) or 0
    local inW = (tonumber(st.ac_input_power_total) or tonumber(dev.ac_in_w) or 0)
      + (tonumber(st.dc_input_power_total) or 0)
    local batt = dev.soc <= 20 and "🪫" or "🔋"
    local title = string.format("⚡+%dW %s%d%% \u{2B06}\u{FE0E} -%dW",
      math.floor(inW + 0.5), batt, math.floor(dev.soc), math.floor(outW + 0.5))
    if dev.stale then
      title = title .. "*"
    end
    ext.app.barSet("battery", 30, title, string.format("%s · %s%s",
      dev.name or "Battery", dev.ts or "", dev.stale and " (stale)" or ""))
  end)
end

ext.app.barOnClick(ext.app.updateBatterySoc)
ext.cache.batteryTimer = hs.timer.doEvery(60, ext.app.updateBatterySoc)
ext.app.updateBatterySoc()
