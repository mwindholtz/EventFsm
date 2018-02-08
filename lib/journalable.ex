defprotocol EventFsm.Journalable do
  def to_entry(term)
end
