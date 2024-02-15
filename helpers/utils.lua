-- iterates a table and returns true if expected value is found there
function contains(tab, value)
    for _, val in ipairs(tab) do
        if val == value then
            return true
        end
    end

    return false
end