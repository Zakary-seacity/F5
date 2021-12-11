RMenu = setmetatable({}, RMenu)

local TotalMenus = {}
---Add
---@param Type string
---@param Name string
---@param Menu table
---@return _G
---@public
function RMenu.Add(Type, Name, Menu)
    if RMenu[Type] ~= nil then
        RMenu[Type][Name] = {
            Menu = Menu
        }
    else
        RMenu[Type] = {}
        RMenu[Type][Name] = {
            Menu = Menu
        }
    end
    return table.insert(TotalMenus, Menu)
end


---Add
---@param Type string
---@param Name string
---@param Menu table
---@return RMenu
---@public


---Get
---@param Type string
---@param Name string
---@return table
---@protected
function RMenu:Get(Type, Name)
    if self[Type] ~= nil and self[Type][Name] ~= nil then
        return self[Type][Name].Menu
    end
end

---ChangeAllColor
---@param Color table
---@protected
function RMenu:ChangeAllColor(Color)
    for i=1,#TotalMenus,1 do
      TotalMenus[i]:EditSpriteColor(Settings.Color)
    end
end
  

---Settings
---@param Type string
---@param Name string
---@param Settings string
---@param Value any
---@return void
---@protected
function RMenu:Settings(Type, Name, Settings, Value)
    if Value ~= nil then
        self[Type][Name][Settings] = Value
    else
        return self[Type][Name][Settings]
    end
end

---Delete
---@param Type string
---@param Name string
---@return void
---@protected
function RMenu:Delete(Type, Name)
    self[Type][Name] = nil
    collectgarbage()
end

---DeleteType
---@param Type string
---@return void
---@public
function RMenu:DeleteType(Type)
    self[Type] = nil
    collectgarbage()
end



--[[
RMenu.Add('mugshot', 'selector', RageUI.CreateMenu("Test", "Title", 15, 250))

RMenu:Get('mugshot', 'selector').Closed = function()
    -- TODO
end

RMenu:Settings('mugshot', 'selector', 'EnableMouse', false)

RMenu:Delete('mugshot', 'selector')
]]--