class User < ApplicationRecord
	has_many :clients

	def self.from_omniauth(auth)
		where(email: auth.info.email).first_or_initialize.tap do |user|
			user.name = auth.info.name
			user.email = auth.info.email
			user.username = auth.info.email
			user.password = auth.info.password
			user.role = ''
			user.save!
		end
	end
end
