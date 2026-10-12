ardour {
  ["type"] = "dsp",
  name = "MIDI Velocity Expand",
  category = "Utility",
  license = "MIT",
  author = "dotfiles",
  description = [[Expand the velocity range of a MIDI performance.]]
}

function dsp_ioconfig ()
  return { { midi_in = 1, midi_out = 1, audio_in = 0, audio_out = 0 } }
end

function dsp_params ()
  return {
    { ["type"] = "input", name = "Soft input", min = 2, max = 126, default = 45, integer = true },
    { ["type"] = "input", name = "Loud input", min = 3, max = 127, default = 90, integer = true },
    { ["type"] = "input", name = "Soft output", min = 1, max = 126, default = 20, integer = true },
    { ["type"] = "input", name = "Loud output", min = 2, max = 127, default = 110, integer = true }
  }
end

function dsp_run (_, _, n_samples)
  local controls = CtrlPorts:array()
  local soft_in = math.min(126, math.max(2, math.floor(controls[1] + 0.5)))
  local loud_in = math.min(127, math.max(soft_in + 1, math.floor(controls[2] + 0.5)))
  local soft_out = math.min(126, math.max(1, math.floor(controls[3] + 0.5)))
  local loud_out = math.min(127, math.max(soft_out + 1, math.floor(controls[4] + 0.5)))

  local function map_velocity (velocity)
    local mapped
    if velocity <= soft_in then
      mapped = 1 + (velocity - 1) * (soft_out - 1) / (soft_in - 1)
    elseif velocity <= loud_in then
      mapped = soft_out + (velocity - soft_in) * (loud_out - soft_out) / (loud_in - soft_in)
    else
      mapped = loud_out + (velocity - loud_in) * (127 - loud_out) / (127 - loud_in)
    end
    return math.min(127, math.max(1, math.floor(mapped + 0.5)))
  end

  local count = 1
  for _, event in pairs(midiin) do
    local data = event["data"]
    if #data == 3 and data[1] >> 4 == 9 and data[3] > 0 then
      data[3] = map_velocity(data[3])
    end
    midiout[count] = { time = event["time"], data = data }
    count = count + 1
  end
end
