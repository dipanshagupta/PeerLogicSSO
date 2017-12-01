class Key < ApplicationRecord
  before_save do
    self.ttl = self.ttl * 1000 * 60 * 60
  end

end
