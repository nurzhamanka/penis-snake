local Entities = {
    active = true,
    entity_list = {}
}

function Entities:add(entity)
    table.insert(self.entity_list, entity)
end

function Entities:addMany(entities)
    for k, entity in pairs(entities) do
        table.insert(self.entity_list, entity)
    end
end

function Entities:remove(entity)
    for i, e in ipairs(self.entity_list) do
        if e == entity then
            table.remove(self.entity_list, i)
            return
        end
    end
end

function Entities:removeAt(index)
    table.remove(self.entity_list, index)
end

function Entities:clear()
    self.entity_list = {}
end

function Entities:draw()
  for i, e in ipairs(self.entity_list) do
    e:draw(i)
  end
end

function Entities:update(dt)
  for i, e in ipairs(self.entity_list) do
    e:update(dt, i)
  end
end

function Entities:update_rev(dt)
    for i=#self.entity_list, 1, -1 do
        local e = self.entity_list[i]
        e:update(dt, i)
    end
end

return Entities
