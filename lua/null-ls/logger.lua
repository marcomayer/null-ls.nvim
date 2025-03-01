local c = require("null-ls.config")
local log = {}

--- Adds a log entry using Plenary.log
---@param msg any
---@param level string [same as vim.log.log_levels]
function log:add_entry(msg, level)
    assert(type(level) == "string")
    if self.__handle then
        -- plenary uses lower-case log levels
        self.__handle[level:lower()](msg)
        return
    end

    local default_opts = {
        plugin = "null-ls",
        level = c.get().log.level or "warn",
        use_console = c.get().log.use_console,
        info_level = 4,
    }
    if c.get().debug then
        default_opts.use_console = false
        default_opts.level = "trace"
    end

    local handle = require("plenary.log").new(default_opts)
    handle[level:lower()](msg)
    self.__handle = handle
end

---Retrieves the path of the logfile
---@return string path of the logfile
function log:get_path()
    return string.format("%s/%s.log", vim.fn.stdpath("cache"), "null-ls")
end

---Add a log entry at TRACE level
---@param msg any
function log:trace(msg)
    self:add_entry(msg, "TRACE")
end

---Add a log entry at DEBUG level
---@param msg any
function log:debug(msg)
    self:add_entry(msg, "DEBUG")
end

---Add a log entry at INFO level
---@param msg any
function log:info(msg)
    self:add_entry(msg, "INFO")
end

---Add a log entry at WARN level
---@param msg any
function log:warn(msg)
    self:add_entry(msg, "WARN")
end

---Add a log entry at ERROR level
---@param msg any
function log:error(msg)
    self:add_entry(msg, "ERROR")
end

setmetatable({}, log)
return log
