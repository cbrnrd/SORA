require 'rbnacl'
require 'core'

# The client will compare the hash instead of the message
def sha256(msg)
  RbNaCl::Hash.sha256(msg)
end
