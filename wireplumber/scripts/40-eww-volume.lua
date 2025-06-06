-- 40-eww-volume.lua  –  push sink-volume to Eww
-- If you use a different variable name than current_volume_poll,
-- change the string in update_eww() below.
local core = ...
local logger = Log.open_topic("eww-vol")

local function calc_level(props)
  -- PipeWire stores cubic-encoded per-channel volumes (0.0–1.0)
  local v = props.channelVolumes and props.channelVolumes[1]
  if not v then return nil end
  return math.floor((v) ^ (1 / 3) * 100 + 0.5) -- 0–100 %
end

local function update_eww(lvl)
  -- replace with full path to `eww` if it’s not on $PATH for WP

  core:spawnv { "eww", "update", "current_volume_poll=" .. lvl }

  --os.execute(string.format("eww update current_volume_poll=%d", lvl))
end

local om = ObjectManager {
  Interest {
  type = "node",
  Constraint { "media.class", "equals", "Audio/Sink", type = "pw-global" },
  }
}

om:connect("object-added", function(_, node)
  -- push current value right away
  for p in node:iterate_params("Props") do
  local lvl = calc_level(p:parse().properties)
  if lvl then update_eww(lvl) end
  end

  -- react to every later change
  node:connect("params-changed", function(_, id)
  if id ~= "Props" then return end
  for p in node:iterate_params("Props") do
  local props = p:parse().properties
  local lvl   = calc_level(props)
  if lvl then update_eww(lvl) end
  end
  end)
end)

om:activate()
