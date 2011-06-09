require 'anvl/element'
require 'anvl/document'
module ANVL
  # Parse an ANVL document into a hash
  def self.parse *args
    Document.parse *args
  end

  # Serialize a Hash to an ANVL string
  def self.to_anvl *args
    anvl = Document.parse *args
    anvl.to_s
  end
end
