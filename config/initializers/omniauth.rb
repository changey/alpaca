Rails.application.config.middleware.use OmniAuth::Builder do

	if Rails.env.production?
		provider :facebook, '448228238605607', 'c08726b1b7abdeb53a3c498f875ca3f7'
	else  
		provider :facebook, '537160112989251', 'a14e855308b2dd8877d7bfcbd9b98c29'
	end

	OmniAuth.config.on_failure = Proc.new { |env|
	  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
end
