--- @meta

--- @class BufferText
--- @field text string|nil
--- @field range BufferLocation|nil

--- @class BeanTransaction
--- @field narration BufferText?
--- @field date BufferText?
--- @field txn BufferText?
--- @field postings BeanPosting[]?
--- @field range BufferLocation?

--- @class BeanPosting
--- @field account BufferText?
--- @field amount BufferText?
