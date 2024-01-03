local wezterm = require 'wezterm'

local module = {}

local function is_array(o)
    if o ~= nil and type(o) == "table" and o[1] ~= nil then
        return true
    end

    return false
end

local function dim_color(n, c)
    return module.transform(n, c)
end

-- local function dim_array(name, ac)
--     local dimmed = {}

--     for i, v in pairs(ac) do
--         dimmed[i] = dim_color(name, v)
--     end

--     return dimmed
-- end

local function dim_table(table)
    local dimmed = {}

    for i, v in pairs(table) do
        if type(v) == "string" then
            dimmed[i] = dim_color(i, v)
        -- elseif is_array(v) then
        --     dimmed[i] = dim_array(i, v)
        else
            dimmed[i] = dim_table(v)
        end
    end

    return dimmed
end

function module:dim(schema, transform)
    self.transform = transform

    return dim_table(schema)
end

return module